package withu.schedule.service;

import static withu.global.exception.ExceptionCode.NOT_USERS_SCHEDULE;
import static withu.global.exception.ExceptionCode.SCHEDULE_CONFLICT;
import static withu.global.exception.ExceptionCode.SCHEDULE_NOT_FOUND;
import static withu.global.exception.ExceptionCode.TEAM_NOT_FOUND;
import static withu.global.exception.ExceptionCode.USER_NOT_LEADER;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import withu.global.exception.CustomException;
import withu.global.utils.TranslationUtil;
import withu.member.entity.Member;
import withu.schedule.dto.ScheduleRequestDto;
import withu.schedule.dto.ScheduleResponseDto;
import withu.schedule.dto.ScheduleUpdateDto;
import withu.schedule.entity.Schedule;
import withu.schedule.enums.ScheduleType;
import withu.schedule.repository.ScheduleRepository;
import withu.team.entity.Team;
import withu.team.repository.TeamRepository;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final TeamRepository teamRepository;
    private final TranslationUtil translationUtil;

    @Transactional(readOnly = true)
    public List<ScheduleResponseDto> getMorningSchedules(LocalDate date, Member member) {
        LocalDateTime start = date.atTime(0, 0);
        LocalDateTime end = date.atTime(12, 0);
        return getFilteredSchedules(start, end, member);
    }

    @Transactional(readOnly = true)
    public List<ScheduleResponseDto> getAfternoonSchedules(LocalDate date, Member member) {
        LocalDateTime start = date.atTime(13, 0);
        LocalDateTime end = date.atTime(23, 59, 59);
        return getFilteredSchedules(start, end, member);
    }

    private List<ScheduleResponseDto> getFilteredSchedules(LocalDateTime start, LocalDateTime end, Member member) {
        List<Schedule> allSchedules = scheduleRepository.findByMemberAndTimeBetween(member, start, end);

        List<Schedule> personalSchedules = allSchedules.stream()
            .filter(s -> s.getType() == ScheduleType.PERSONAL)
            .collect(Collectors.toList());

        List<Schedule> teamSchedules = allSchedules.stream()
            .filter(s -> s.getType() == ScheduleType.TEAM)
            .filter(teamSchedule -> personalSchedules.stream()
                .noneMatch(personalSchedule ->
                    isOverlapping(personalSchedule, teamSchedule)))
            .toList();

        personalSchedules.addAll(teamSchedules);

        return personalSchedules.stream()
            .map(schedule -> ScheduleResponseDto.fromWithTranslation(schedule, member.getLanguageCode(), translationUtil))
            .collect(Collectors.toList());
    }

    private boolean isOverlapping(Schedule schedule1, Schedule schedule2) {
        return !schedule1.getEndTime().isBefore(schedule2.getStartTime()) &&
            !schedule2.getEndTime().isBefore(schedule1.getStartTime());
    }

    @Transactional
    public ScheduleResponseDto createSchedule(ScheduleRequestDto requestDto, Member member) {
        Team team = null;

        if (requestDto.getType() == ScheduleType.TEAM) {
            team = teamRepository.findById(requestDto.getTeamId())
                .orElseThrow(() -> new CustomException(TEAM_NOT_FOUND));

            if (!isTeamLeader(member, team)) {
                throw new CustomException(USER_NOT_LEADER);
            }

            // 팀 일정 중복 검사
            List<Schedule> conflictingTeamSchedules = scheduleRepository.findConflictingTeamSchedules(
                team, requestDto.getStartTime(), requestDto.getEndTime());
            if (!conflictingTeamSchedules.isEmpty()) {
                throw new CustomException(SCHEDULE_CONFLICT);
            }
        }

        // 개인 일정 중복 검사
        List<Schedule> conflictingSchedules = scheduleRepository.findConflictingSchedules(
            member, requestDto.getStartTime(), requestDto.getEndTime());
        if (!conflictingSchedules.isEmpty()) {
            throw new CustomException(SCHEDULE_CONFLICT);
        }

        Schedule schedule = Schedule.builder()
            .title(requestDto.getTitle())
            .member(member)
            .team(team)
            .startTime(requestDto.getStartTime())
            .endTime(requestDto.getEndTime())
            .description(requestDto.getDescription())
            .type(requestDto.getType())
            .build();

        Schedule savedSchedule = scheduleRepository.save(schedule);
        return ScheduleResponseDto.from(savedSchedule);
    }

    @Transactional
    public ScheduleResponseDto updateSchedule(Long scheduleId, ScheduleUpdateDto updateDto,
        Member member) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
            .orElseThrow(() -> new CustomException(SCHEDULE_NOT_FOUND));

        // 일정 생성자 또는 팀장만 수정 가능
        if (!schedule.getMember().equals(member) &&
            (schedule.getTeam() == null || !isTeamLeader(member, schedule.getTeam()))) {
            throw new CustomException(NOT_USERS_SCHEDULE);
        }

        Team team = null;
        if (updateDto.getType() == ScheduleType.TEAM) {
            team = teamRepository.findById(updateDto.getTeamId())
                .orElseThrow(() -> new CustomException(TEAM_NOT_FOUND));
        }

        schedule.update(
            updateDto.getTitle(),
            updateDto.getStartTime(),
            updateDto.getEndTime(),
            updateDto.getDescription(),
            updateDto.getType(),
            team
        );

        Schedule updatedSchedule = scheduleRepository.save(schedule);
        return ScheduleResponseDto.from(updatedSchedule);
    }

    private boolean isTeamLeader(Member member, Team team) {
        if (team == null || member == null) {
            return false;
        }
        Member leader = team.getLeader();
        return leader != null && leader.equals(member);
    }

    @Transactional
    public void deleteSchedule(Long scheduleId, Member member) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
            .orElseThrow(() -> new CustomException(SCHEDULE_NOT_FOUND));

        // 일정 생성자 또는 팀장만 삭제 가능
        if (!hasPermissionToModify(schedule, member)) {
            throw new CustomException(NOT_USERS_SCHEDULE);
        }

        scheduleRepository.delete(schedule);
    }

    private boolean hasPermissionToModify(Schedule schedule, Member member) {
        return schedule.getMember().equals(member) ||
            (schedule.getTeam() != null && isTeamLeader(member, schedule.getTeam()));
    }
}