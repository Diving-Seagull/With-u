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
        Member updatedMember = Member.builder()
            .id(member.getId())
            .email(member.getEmail())
            .name(updateRequestDto.getName() != null && !updateRequestDto.getName().isEmpty()
                ? updateRequestDto.getName() : member.getName())
            .profile(updateRequestDto.getProfile() != null && !updateRequestDto.getProfile().isEmpty()
                ? updateRequestDto.getProfile() : member.getProfile())
            .socialType(member.getSocialType())
            .build();

        Member savedMember = memberRepository.save(updatedMember);

        return MemberResponseDto.builder()
            .email(savedMember.getEmail())
            .name(savedMember.getName())
            .profile(savedMember.getProfile())
            .socialType(savedMember.getSocialType())
            .build();
    }
}
