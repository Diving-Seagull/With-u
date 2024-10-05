package withu.global.utils.dto;

import com.google.cloud.translate.Detection;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DetectLanguageResponseDto {

    private String languageCode;
    private Float confidence;

    public static DetectLanguageResponseDto from(Detection detection) {
        return DetectLanguageResponseDto.builder()
            .languageCode(detection.getLanguage())
            .confidence(detection.getConfidence())
            .build();
    }
}