package withu.notice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.member.entity.Member;
import withu.notice.entity.Notice;
import withu.team.entity.Team;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoticeRequestDto {

    @NotNull(message = "팀 ID는 필수입니다.")
    private Long teamId;

    @NotBlank(message = "제목은 필수입니다.")
    @Size(max = 100, message = "제목은 100자를 초과할 수 없습니다.")
    private String title;

    @NotBlank(message = "내용은 필수입니다.")
    @Size(max = 5000, message = "내용은 5000자를 초과할 수 없습니다.")
    private String content;

    public Notice toEntity(Team team, Member author) {
        return Notice.builder()
            .team(team)
            .title(this.title)
            .content(this.content)
            .author(author)
            .build();
    }
}