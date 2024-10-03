package withu.schedule.service;

import static withu.global.exception.ExceptionCode.TEAM_NOT_FOUND;

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