package withu.notice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoticeUpdateRequestDto {

    @NotBlank(message = "제목은 필수입니다.")
    @Size(max = 100, message = "제목은 100자를 초과할 수 없습니다.")
    private String title;

    @NotBlank(message = "내용은 필수입니다.")
    @Size(max = 5000, message = "내용은 5000자를 초과할 수 없습니다.")
    private String content;

    @Builder.Default
    @Size(max = 5, message = "이미지는 최대 5개까지만 등록할 수 있습니다.")
    private List<ImageDto> newImages = new ArrayList<>();

    private List<Long> imageIdsToRemove;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ImageDto {
        @NotBlank(message = "이미지 데이터는 필수입니다.")
        private String base64Data;

        @NotBlank(message = "이미지 콘텐츠 타입은 필수입니다.")
        private String contentType;
    }
}