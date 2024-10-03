package withu.schedule.service;

import static withu.global.exception.ExceptionCode.TEAM_NOT_FOUND;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;
import withu.schedule.dto.ScheduleRequestDto;
import withu.schedule.dto.ScheduleResponseDto;
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
            .map(ScheduleResponseDto::from)
            .collect(Collectors.toList());
    }

    private boolean isOverlapping(Schedule schedule1, Schedule schedule2) {
        return !schedule1.getEndTime().isBefore(schedule2.getStartTime()) &&
            !schedule2.getEndTime().isBefore(schedule1.getStartTime());
    }

    @Transactional
    public ScheduleResponseDto createSchedule(ScheduleRequestDto requestDto, Member member) {
        Team team = null;

        // todo 팀 일정 등록시 팀장만 가능하도록 유효성 검사 진행?

        if (requestDto.getType() == ScheduleType.TEAM) {
            team = teamRepository.findById(requestDto.getTeamId())
                .orElseThrow(() -> new CustomException(TEAM_NOT_FOUND));
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
}