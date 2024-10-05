package withu.member.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import withu.global.validation.ValidLanguageCode;
import withu.member.enums.Role;

@Getter
@NoArgsConstructor
public class MemberInitRequestDto {

    @NotNull(message = "역할은 필수입니다.")
    private Role role;

    @NotBlank(message = "설명은 필수입니다.")
    @Size(max = 50, message = "설명은 50자를 초과할 수 없습니다.")
    private String description;

    @NotBlank(message = "deviceUUID는 필수입니다.")
    private String deviceUuid;

    private String profileImage;

    @Size(max = 20, message = "이름은 20자를 초과할 수 없습니다.")
    private String name;

    private Integer teamCode;

    @ValidLanguageCode(message = "유효한 ISO 언어 코드를 입력해주세요.")
    @Size(min = 2, max = 10, message = "언어 코드는 2자 이상 10자 이하여야 합니다.")
    private String languageCode;
}