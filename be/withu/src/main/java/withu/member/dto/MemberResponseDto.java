package withu.member.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.member.entity.Member;
import withu.member.enums.SocialType;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberResponseDto {

    private Long id;
    private String email;
    private String name;
    private String profile;
    private SocialType socialType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static MemberResponseDto toDto(Member member) {
        return MemberResponseDto.builder()
            .id(member.getId())
            .email(member.getEmail())
            .name(member.getName())
            .profile(member.getProfile())
            .socialType(member.getSocialType())
            .createdAt(member.getCreatedAt())
            .updatedAt(member.getUpdatedAt())
            .build();
    }
}
