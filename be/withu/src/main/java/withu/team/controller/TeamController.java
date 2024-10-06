package withu.team.controller;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.dto.MemberResponseDto;
import withu.member.entity.Member;
import withu.team.service.TeamService;

@RestController
@RequestMapping("/api/team")
@RequiredArgsConstructor
public class TeamController {

    private final TeamService teamService;

    @GetMapping("/members")
    public ResponseEntity<List<MemberResponseDto>> getTeamMembers(@LoginMember Member member) {
        return ResponseEntity.ok(teamService.getTeamMembers(member));
    }

    @DeleteMapping("/members/{memberId}")
    public ResponseEntity<Void> removeMember(@LoginMember Member leader,
        @PathVariable Long memberId) {
        teamService.removeMember(leader, memberId);
        return ResponseEntity.noContent().build();
    }
}