package withu.auth.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KakaoUserInfo {

    private KakaoAccount kakaoAccount;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class KakaoAccount {

        private String email;
        private Profile profile;

        @Getter
        @NoArgsConstructor
        @AllArgsConstructor
        @Builder
        public static class Profile {

            private String nickname;
            @JsonProperty("profile_image_url")
            private String profileImageUrl;
        }
    }

    public static class KakaoUserInfoBuilder {
        public KakaoUserInfoBuilder email(String email) {
            if (kakaoAccount == null) {
                kakaoAccount = new KakaoAccount();
            }
            kakaoAccount.email = email;
            return this;
        }

        public KakaoUserInfoBuilder nickname(String nickname) {
            if (kakaoAccount == null) {
                kakaoAccount = new KakaoAccount();
            }
            if (kakaoAccount.profile == null) {
                kakaoAccount.profile = new KakaoAccount.Profile();
            }
            kakaoAccount.profile.nickname = nickname;
            return this;
        }

        public KakaoUserInfoBuilder profileImageUrl(String profileImageUrl) {
            if (kakaoAccount == null) {
                kakaoAccount = new KakaoAccount();
            }
            if (kakaoAccount.profile == null) {
                kakaoAccount.profile = new KakaoAccount.Profile();
            }
            kakaoAccount.profile.profileImageUrl = profileImageUrl;
            return this;
        }
    }

    public String getEmail() {
        return kakaoAccount != null ? kakaoAccount.getEmail() : null;
    }

    public String getNickname() {
        return kakaoAccount != null && kakaoAccount.getProfile() != null
            ? kakaoAccount.getProfile().getNickname() : null;
    }

    public String getProfileImageUrl() {
        return kakaoAccount != null && kakaoAccount.getProfile() != null
            ? kakaoAccount.getProfile().getProfileImageUrl() : null;
    }
}