package withu.notice.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.notice.entity.Notice;
import withu.notice.entity.NoticeImage;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoticeResponseDto {
    private Long id;
    private Long teamId;
    private String title;
    private String content;
    private Long authorId;
    private String authorName;
    private List<NoticeImageDto> images;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Getter
    @AllArgsConstructor
    public static class NoticeImageDto {
        private Long id;
        private String imageUrl;
        private int order;
    }

    public static NoticeResponseDto from(Notice notice) {
        return NoticeResponseDto.builder()
            .id(notice.getId())
            .teamId(notice.getTeam().getId())
            .title(notice.getTitle())
            .content(notice.getContent())
            .authorId(notice.getAuthor().getId())
            .authorName(notice.getAuthor().getName())
            .images(notice.getImages().stream()
                .map(image -> new NoticeImageDto(image.getId(), image.getImageUrl(), image.getOrder()))
                .collect(Collectors.toList()))
            .createdAt(notice.getCreatedAt())
            .updatedAt(notice.getUpdatedAt())
            .build();
    }
}