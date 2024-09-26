package withu.auth.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.auth.client.GoogleClient;
import withu.auth.client.KakaoClient;
import withu.auth.dto.GoogleUserInfo;
import withu.auth.dto.KakaoUserInfo;
import withu.auth.dto.SocialAuthRequestDto;
import withu.auth.dto.TokenResponseDto;
import withu.global.exception.CustomException;
import withu.global.exception.ExceptionCode;
import withu.global.utils.JwtUtil;
import withu.member.entity.Member;
import withu.member.enums.SocialType;
import withu.member.repository.MemberRepository;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final MemberRepository memberRepository;
    private final JwtUtil jwtUtil;
    private final KakaoClient kakaoClient;
    private final GoogleClient googleClient;

    @Transactional
    public TokenResponseDto kakaoAuth(SocialAuthRequestDto requestDto) {
        KakaoUserInfo kakaoUserInfo = kakaoClient.getKakaoUserInfo(requestDto.getSocialToken());

        Member member = memberRepository.findByEmail(kakaoUserInfo.getEmail())
            .orElseGet(() -> registerNewKakaoMember(kakaoUserInfo, requestDto.getFirebaseToken()));

        String jwtToken = jwtUtil.generateToken(member.getEmail());
        return new TokenResponseDto(jwtToken);
    }

    @Transactional
    public TokenResponseDto googleAuth(SocialAuthRequestDto requestDto) {
        GoogleUserInfo googleUserInfo = googleClient.getGoogleUserInfo(requestDto.getSocialToken());

        Member member = memberRepository.findByEmail(googleUserInfo.getEmail())
            .orElseGet(() -> registerNewGoogleMember(googleUserInfo, requestDto.getFirebaseToken()));

        String jwtToken = jwtUtil.generateToken(member.getEmail());
        return new TokenResponseDto(jwtToken);
    }

    private Member registerNewKakaoMember(KakaoUserInfo kakaoUserInfo, String firebaseToken) {
        if (firebaseToken == null) {
            throw new CustomException(ExceptionCode.FIREBASE_TOKEN_MISSING);
        }
        Member newMember = Member.builder()
            .email(kakaoUserInfo.getEmail())
            .name(kakaoUserInfo.getNickname())
            .profile(kakaoUserInfo.getProfileImageUrl())
            .socialType(SocialType.KAKAO)
            .firebaseToken(firebaseToken)
            .build();
        return memberRepository.save(newMember);
    }

    private Member registerNewGoogleMember(GoogleUserInfo googleUserInfo, String firebaseToken) {
        if (firebaseToken == null) {
            throw new IllegalArgumentException("Firebase token is required for signup");
        }
        Member newMember = Member.builder()
            .email(googleUserInfo.getEmail())
            .name(googleUserInfo.getName())
            .profile(googleUserInfo.getPicture())
            .socialType(SocialType.GOOGLE)
            .firebaseToken(firebaseToken)
            .build();
        return memberRepository.save(newMember);
    }
}
