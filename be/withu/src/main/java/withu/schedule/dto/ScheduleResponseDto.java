package withu.schedule.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import withu.global.utils.TranslationUtil;
import withu.schedule.entity.Schedule;
import withu.schedule.enums.ScheduleType;

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

    public static ScheduleResponseDto fromWithTranslation(Schedule schedule, String languageCode, TranslationUtil translationUtil) {
        ScheduleResponseDto dto = from(schedule);
        dto.title = translationUtil.translateText(dto.title, languageCode);
        dto.description = translationUtil.translateText(dto.description, languageCode);
        return dto;
    }
}