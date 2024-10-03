package withu.schedule.dto;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import withu.schedule.enums.ScheduleType;

import java.time.LocalDateTime;

@Getter
@Setter
public class ScheduleUpdateDto {

    @NotBlank(message = "제목은 필수입니다.")
    @Size(max = 100, message = "제목은 100자를 초과할 수 없습니다.")
    private String title;

    @NotNull(message = "시작 시간은 필수입니다.")
    @Future(message = "시작 시간은 현재 시간 이후여야 합니다.")
    private LocalDateTime startTime;

    @NotNull(message = "종료 시간은 필수입니다.")
    @Future(message = "종료 시간은 현재 시간 이후여야 합니다.")
    private LocalDateTime endTime;

    @Size(max = 500, message = "설명은 500자를 초과할 수 없습니다.")
    private String description;

    @NotNull(message = "스케줄 타입은 필수입니다.")
    private ScheduleType type;

    private Long teamId;

    @AssertTrue(message = "종료 시간은 시작 시간 이후여야 합니다.")
    public boolean isEndTimeAfterStartTime() {
        return endTime != null && startTime != null && endTime.isAfter(startTime);
    }

    @AssertTrue(message = "팀 스케줄인 경우 팀 ID는 필수입니다.")
    public boolean isTeamIdPresentForTeamSchedule() {
        return type != ScheduleType.TEAM || (type == ScheduleType.TEAM && teamId != null);
    }
}