package withu.member.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.member.enums.Role;

@Getter
@NoArgsConstructor
public class MemberInitRequestDto {

    @NotNull
    private Role role;

    @NotBlank
    @Size(max = 50, message = "설명은 50자를 초과할 수 없습니다.")
    private String description;

    @NotBlank
    private String deviceUuid;

    @NotBlank
    private String profileImage;

    @NotBlank(message = "이름은 필수입니다.")
    @Size(max = 20, message = "이름은 20자를 초과할 수 없습니다.")
    private String name;
}