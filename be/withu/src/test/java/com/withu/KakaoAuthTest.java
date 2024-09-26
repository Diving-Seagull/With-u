package com.withu;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import withu.auth.dto.SocialAuthRequestDto;
import withu.auth.dto.TokenResponseDto;
import withu.auth.service.AuthService;
import withu.global.utils.JwtUtil;
import withu.member.entity.Member;
import withu.member.enums.SocialType;
import withu.member.repository.MemberRepository;
import withu.auth.client.KakaoClient;
import withu.auth.dto.KakaoUserInfo;

import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {

    @Mock
    private KakaoClient kakaoClient;

    @Mock
    private MemberRepository memberRepository;

    @Mock
    private JwtUtil jwtUtil;

    @InjectMocks
    private AuthService authService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testKakaoAuth_ExistingUser() {
        // Arrange
        String socialToken = "kakao_test_token";
        String firebaseToken = "firebase_test_token";
        String email = "test@example.com";
        String name = "Test User";
        String profileImageUrl = "http://example.com/profile.jpg";

        SocialAuthRequestDto requestDto = new SocialAuthRequestDto(socialToken, firebaseToken);

        KakaoUserInfo kakaoUserInfo = KakaoUserInfo.builder()
            .kakaoAccount(KakaoUserInfo.KakaoAccount.builder()
                .email(email)
                .profile(KakaoUserInfo.KakaoAccount.Profile.builder()
                    .nickname(name)
                    .profileImageUrl(profileImageUrl)
                    .build())
                .build())
            .build();

        Member existingMember = Member.builder()
            .email(email)
            .name(name)
            .profile(profileImageUrl)
            .socialType(SocialType.KAKAO)
            .build();

        String expectedJwtToken = "jwt_test_token";

        when(kakaoClient.getKakaoUserInfo(socialToken)).thenReturn(kakaoUserInfo);
        when(memberRepository.findByEmail(email)).thenReturn(Optional.of(existingMember));
        when(jwtUtil.generateToken(email)).thenReturn(expectedJwtToken);

        // Act
        TokenResponseDto result = authService.kakaoAuth(requestDto);

        // Assert
        assertNotNull(result);
        assertEquals(expectedJwtToken, result.getToken());
        verify(kakaoClient).getKakaoUserInfo(socialToken);
        verify(memberRepository).findByEmail(email);
        verify(jwtUtil).generateToken(email);
        verifyNoMoreInteractions(memberRepository);
    }

    @Test
    void testKakaoAuth_NewUser() {
        // Arrange
        String socialToken = "kakao_test_token";
        String firebaseToken = "firebase_test_token";
        String email = "newuser@example.com";
        String name = "New User";
        String profileImageUrl = "http://example.com/newprofile.jpg";

        SocialAuthRequestDto requestDto = new SocialAuthRequestDto(socialToken, firebaseToken);

        KakaoUserInfo kakaoUserInfo = KakaoUserInfo.builder()
            .kakaoAccount(KakaoUserInfo.KakaoAccount.builder()
                .email(email)
                .profile(KakaoUserInfo.KakaoAccount.Profile.builder()
                    .nickname(name)
                    .profileImageUrl(profileImageUrl)
                    .build())
                .build())
            .build();

        Member newMember = Member.builder()
            .email(email)
            .name(name)
            .profile(profileImageUrl)
            .socialType(SocialType.KAKAO)
            .build();

        String expectedJwtToken = "jwt_test_token";

        when(kakaoClient.getKakaoUserInfo(socialToken)).thenReturn(kakaoUserInfo);
        when(memberRepository.findByEmail(email)).thenReturn(Optional.empty());
        when(memberRepository.save(any(Member.class))).thenReturn(newMember);
        when(jwtUtil.generateToken(email)).thenReturn(expectedJwtToken);

        // Act
        TokenResponseDto result = authService.kakaoAuth(requestDto);

        // Assert
        assertNotNull(result);
        assertEquals(expectedJwtToken, result.getToken());

        verify(kakaoClient).getKakaoUserInfo(socialToken);
        verify(memberRepository).findByEmail(email);
        verify(memberRepository).save(any(Member.class));
        verify(jwtUtil).generateToken(email);
    }
}