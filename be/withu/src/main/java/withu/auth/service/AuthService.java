package withu.auth.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.auth.client.KakaoClient;
import withu.auth.dto.KakaoUserInfo;
import withu.auth.dto.TokenResponseDto;
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

    @Transactional
    public TokenResponseDto kakaoLogin(String kakaoAccessToken) {
        // 1. 카카오 액세스 토큰을 사용하여 사용자 정보 가져오기
        KakaoUserInfo kakaoUserInfo = kakaoClient.getKakaoUserInfo(kakaoAccessToken);

        // 2. 사용자 정보로 DB에서 멤버 찾기 또는 새로 생성
        Member member = memberRepository.findByEmail(kakaoUserInfo.getEmail())
            .orElseGet(() -> registerNewKakaoMember(kakaoUserInfo));

        // 3. JWT 토큰 생성
        String jwtToken = jwtUtil.generateToken(member.getEmail());

        return new TokenResponseDto(jwtToken);
    }

    private Member registerNewKakaoMember(KakaoUserInfo kakaoUserInfo) {
        Member newMember = Member.builder()
            .email(kakaoUserInfo.getEmail())
            .name(kakaoUserInfo.getNickname())
            .profile(kakaoUserInfo.getProfileImageUrl())
            .socialType(SocialType.KAKAO)
            .build();
        return memberRepository.save(newMember);
    }
}
