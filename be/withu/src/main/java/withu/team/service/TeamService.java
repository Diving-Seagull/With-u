package withu.team.service;

import static withu.global.exception.ExceptionCode.TEAM_NOT_FOUND;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import withu.global.exception.CustomException;
import withu.team.entity.Team;
import withu.team.repository.TeamRepository;
import withu.member.entity.Member;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TeamService {

    private final TeamRepository teamRepository;

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
}