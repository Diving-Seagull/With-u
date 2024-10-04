package withu.notification.dto;

import java.util.List;
import lombok.Getter;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Positive;

@Getter
public class NotificationRequestDto {

    @NotNull(message = "대상 멤버 ID 리스트는 필수입니다.")
    @Size(min = 1, message = "최소 한 명 이상의 대상 멤버가 필요합니다.")
    private List<@NotNull @Positive(message = "멤버 ID는 양수여야 합니다.") Long> targetMemberIds;
}