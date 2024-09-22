package withu.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.dto.SocialLoginRequestDto;
import withu.auth.dto.TokenResponseDto;
import withu.auth.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/kakao")
    public ResponseEntity<TokenResponseDto> kakakoLogin(
        @RequestBody SocialLoginRequestDto request) {
        TokenResponseDto tokenResponse = authService.kakaoLogin(request.getToken());
        return ResponseEntity.ok(tokenResponse);
    }

    @PostMapping("/google")
    public ResponseEntity<TokenResponseDto> googleLogin(
        @RequestBody SocialLoginRequestDto request) {
        TokenResponseDto tokenResponse = authService.googleLogin(request.getToken());
        return ResponseEntity.ok(tokenResponse);
    }
}