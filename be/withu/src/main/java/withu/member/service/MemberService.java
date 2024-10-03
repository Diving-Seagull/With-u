package withu.member.service;

import static withu.global.exception.ExceptionCode.MEMBER_NOT_IN_TEAM;
import static withu.global.exception.ExceptionCode.TEAM_CODE_REQUIRED;
import static withu.global.exception.ExceptionCode.USER_NOT_FOUND;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.dto.MemberResponseDto;
import withu.member.dto.MemberInitRequestDto;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;
import withu.member.enums.Role;
import withu.team.entity.Team;
import withu.team.service.TeamService;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final TeamService teamService;

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

    public List<MemberResponseDto> getTeamMembers(Member member) {
        if (member.getTeam() == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }
        List<Member> teamMembers = memberRepository.findByTeam(member.getTeam());
        return teamMembers.stream()
            .map(MemberResponseDto::from)
            .collect(Collectors.toList());
    }

    @Transactional
    public MemberResponseDto initMember(Member member, MemberInitRequestDto initDto) {
        Role newRole = initDto.getRole();
        Team team = null;

        if (newRole == Role.LEADER) {
            team = teamService.createTeam(member);
        } else if (newRole == Role.TEAMMATE && initDto.getTeamCode() != null) {
            team = teamService.findTeamByCode(initDto.getTeamCode());
        }

        member.initMember(
            newRole,
            initDto.getName(),
            initDto.getDescription(),
            initDto.getProfileImage(),
            initDto.getDeviceUuid(),
            team
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
