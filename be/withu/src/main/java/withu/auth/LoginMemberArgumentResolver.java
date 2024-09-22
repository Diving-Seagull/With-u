package withu.auth;

import static withu.global.exception.ExceptionCode.TOKEN_EXPIRED;
import static withu.global.exception.ExceptionCode.UNAUTHORIZED;

import lombok.AllArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import withu.global.exception.CustomException;
import withu.global.utils.JwtUtil;
import withu.member.entity.Member;
import withu.member.service.MemberService;

@Component
@AllArgsConstructor
public class LoginMemberArgumentResolver implements HandlerMethodArgumentResolver {

    private final JwtUtil jwtUtil;
    private final MemberService memberService;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterAnnotation(LoginMember.class) != null
            && parameter.getParameterType().equals(Member.class);
    }

    @Override
    public Member resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
        NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        String token = extractToken(webRequest);
        if (token == null) {
            throw new CustomException(UNAUTHORIZED);
        }


        if (jwtUtil.isTokenExpired(token)) {
            throw new CustomException(TOKEN_EXPIRED);
        }

        String memberEmail = jwtUtil.extractMemberEmail(token);
        return memberService.getMemberByEmail(memberEmail);
    }

    private String extractToken(NativeWebRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}