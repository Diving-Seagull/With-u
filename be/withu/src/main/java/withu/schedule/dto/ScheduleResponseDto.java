package withu.schedule.dto;

import lombok.Builder;
import lombok.Getter;
import withu.schedule.entity.Schedule;
import withu.schedule.enums.ScheduleType;

import java.time.LocalDateTime;

@Getter
@Builder
public class ScheduleResponseDto {

    private Long id;
    private String title;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String description;
    private ScheduleType type;
    private Long memberId;
    private String memberName;
    private Long teamId;

    public static ScheduleResponseDto from(Schedule schedule) {
        return ScheduleResponseDto.builder()
            .id(schedule.getId())
            .title(schedule.getTitle())
            .startTime(schedule.getStartTime())
            .endTime(schedule.getEndTime())
            .description(schedule.getDescription())
            .type(schedule.getType())
            .memberId(schedule.getMember().getId())
            .memberName(schedule.getMember().getName())
            .teamId(schedule.getTeam() != null ? schedule.getTeam().getId() : null)
            .build();
    }
}