package withu.member.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.member.entity.Member;
import withu.member.enums.Role;
import withu.member.enums.SocialType;
import withu.team.entity.Team;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberResponseDto {

    private Long id;
    private String email;
    private String name;
    private String description;
    private String profile;
    private SocialType socialType;
    private String deviceUuid;
    private Team team;
    private Role role;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static MemberResponseDto from(Member member) {
        return MemberResponseDto.builder()
            .id(member.getId())
            .email(member.getEmail())
            .name(member.getName())
            .description(member.getDescription())
            .profile(member.getProfile())
            .socialType(member.getSocialType())
            .deviceUuid(member.getDeviceUuid())
            .team(member.getTeam())
            .role(member.getRole())
            .createdAt(member.getCreatedAt())
            .updatedAt(member.getUpdatedAt())
            .build();
    }
}
