package withu.member.service;

import static withu.global.exception.ExceptionCode.USER_NOT_FOUND;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.global.utils.JwtUtil;
import withu.member.dto.MemberResponseDto;
import withu.member.dto.MemberUpdateRequestDto;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    public Member getMemberEntityByEmail(String memberEmail) {
        return memberRepository.findByEmail(memberEmail)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND));
    }

    public MemberResponseDto getMember(Member member) {
        return MemberResponseDto.builder()
            .email(member.getEmail())
            .name(member.getName())
            .profile(member.getProfile())
            .socialType(member.getSocialType())
            .build();
    }

    public MemberResponseDto getMemberByEmail(String memberEmail) {
        return MemberResponseDto.toDto(memberRepository.findByEmail(memberEmail)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND)));
    }

    @Transactional
    public MemberResponseDto updateMemberInfo(Member member, MemberUpdateRequestDto updateRequestDto) {
        // todo
//        // 이름과 프로필 수정
//        member.updateInfo(updateRequestDto.getName(), updateRequestDto.getProfile());
//
//        // 수정된 회원 정보 저장
//        Member newMember = memberRepository.save(member);

        // 수정된 정보를 DTO로 반환
        return MemberResponseDto.builder()
            .email(member.getEmail())
            .name(member.getName())
            .profile(member.getProfile())
            .socialType(member.getSocialType())
            .build();
    }
}
