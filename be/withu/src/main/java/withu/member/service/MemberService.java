package withu.member.service;

import static withu.global.exception.ExceptionCode.USER_NOT_FOUND;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.dto.MemberResponseDto;
import withu.member.dto.MemberInitRequestDto;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    @Transactional
    public Member getMemberEntityByEmail(String memberEmail) {
        return memberRepository.findByEmail(memberEmail)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND));
    }

    @Transactional
    public MemberResponseDto getMember(Member member) {
        return MemberResponseDto.from(member);
    }

    @Transactional
    public MemberResponseDto getMemberByEmail(String memberEmail) {
        return MemberResponseDto.from(memberRepository.findByEmail(memberEmail)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND)));
    }

    @Transactional
    public MemberResponseDto initMember(Member member, MemberInitRequestDto updateDto) {
        member.initMember(
            updateDto.getRole(),
            updateDto.getDescription(),
            updateDto.getDeviceUuid(),
            updateDto.getProfileImage(),
            updateDto.getName()
        );

        Member updatedMember = memberRepository.save(member);
        return MemberResponseDto.from(updatedMember);
    }

    @Transactional
    public void deleteMember(Member member) {
        member.disable();
        memberRepository.save(member);
    }
}
