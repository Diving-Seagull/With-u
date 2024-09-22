package withu.member.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.dto.MemberResponseDto;
import withu.member.entity.Member;
import withu.member.service.MemberService;

@RestController
@RequestMapping("/api/member")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping
    public ResponseEntity<MemberResponseDto> getMember(@LoginMember Member member){
        return ResponseEntity.ok(memberService.getMember(member));
    }
}