package withu.member.service;

import static withu.global.exception.ExceptionCode.USER_NOT_FOUND;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.global.utils.JwtUtil;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final JwtUtil jwtUtil;

    public Member getMemberByEmail(String memberEmail) {
        return memberRepository.findByEmail(memberEmail)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND));
    }
}
