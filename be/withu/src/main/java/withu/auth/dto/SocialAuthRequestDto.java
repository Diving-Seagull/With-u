package withu.auth.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class SocialAuthRequestDto {

    @NotNull(message = "Social token is required")
    @JsonProperty("token")
    private String socialToken;

    @JsonProperty("firebaseToken")
    private String firebaseToken;
}