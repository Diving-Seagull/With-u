package withu.team.service;

import static withu.global.exception.ExceptionCode.*;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import withu.global.exception.CustomException;
import withu.member.dto.MemberResponseDto;
import withu.member.repository.MemberRepository;
import withu.team.entity.Team;
import withu.team.repository.TeamRepository;
import withu.member.entity.Member;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TeamService {

    private final TeamRepository teamRepository;
    private final MemberRepository memberRepository;

    @Transactional
    public Team createTeam(Member leader) {
        Team team = Team.builder()
            .leader(leader)
            .build();
        return teamRepository.save(team);
    }

    public Team findTeamByCode(Integer teamCode) {
        return teamRepository.findByTeamCode(teamCode)
            .orElseThrow(() -> new CustomException(TEAM_NOT_FOUND));
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
    public void removeMember(Member leader, Long memberId) {
        if (!leader.isLeader()) {
            throw new CustomException(USER_NOT_LEADER);
        }

        Team team = leader.getTeam();
        if (team == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        Member memberToRemove = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND));

        if (!memberToRemove.getTeam().equals(team)) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        memberToRemove.removeFromTeam();
        memberRepository.save(memberToRemove);
    }
}