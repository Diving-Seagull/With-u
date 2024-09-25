package withu.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.dto.SocialAuthRequestDto;
import withu.auth.dto.TokenResponseDto;
import withu.auth.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/kakao")
    public ResponseEntity<TokenResponseDto> kakakoAuth(
        @RequestBody SocialAuthRequestDto requestDto) {
        TokenResponseDto tokenResponse = authService.kakakoAuth(requestDto);
        return ResponseEntity.ok(tokenResponse);
    }

    @PostMapping("/google")
    public ResponseEntity<TokenResponseDto> googleAuth(
        @RequestBody SocialAuthRequestDto requestDto) {
        TokenResponseDto tokenResponse = authService.googleAuth(requestDto);
        return ResponseEntity.ok(tokenResponse);
    }
}