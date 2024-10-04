package withu.notice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.ArrayList;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.member.entity.Member;
import withu.notice.entity.Notice;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoticeRequestDto {

    @NotBlank(message = "제목은 필수입니다.")
    @Size(max = 100, message = "제목은 100자를 초과할 수 없습니다.")
    private String title;

    @NotBlank(message = "내용은 필수입니다.")
    @Size(max = 5000, message = "내용은 5000자를 초과할 수 없습니다.")
    private String content;

    @Builder.Default
    @Size(max = 5, message = "이미지는 최대 5개까지만 등록할 수 있습니다.")
    private List<String> imageUrls = new ArrayList<>();

    private boolean pinned;

    public Notice toEntity(Member author) {
        Notice notice = Notice.builder()
            .team(author.getTeam())
            .title(this.title)
            .content(this.content)
            .author(author)
            .build();

        if (imageUrls != null && !imageUrls.isEmpty()) {
            imageUrls.forEach(notice::addImage);
        }

        if (pinned) {
            notice.pin();
        }

        return notice;
    }
}