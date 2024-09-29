package withu.notice.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.notice.entity.Notice;

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
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static NoticeResponseDto toDto(Notice notice) {
        return NoticeResponseDto.builder()
            .id(notice.getId())
            .teamId(notice.getTeam().getId())
            .title(notice.getTitle())
            .content(notice.getContent())
            .authorId(notice.getAuthor().getId())
            .authorName(notice.getAuthor().getName())
            .createdAt(notice.getCreatedAt())
            .updatedAt(notice.getUpdatedAt())
            .build();
    }
}