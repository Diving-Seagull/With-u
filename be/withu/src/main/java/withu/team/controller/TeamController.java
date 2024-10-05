package withu.team.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import lombok.RequiredArgsConstructor;
import withu.team.service.TeamService;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.member.dto.MemberResponseDto;

import java.util.List;

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