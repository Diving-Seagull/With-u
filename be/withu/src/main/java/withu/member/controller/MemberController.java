package withu.member.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.dto.MemberResponseDto;
import withu.member.dto.MemberUpdateRequestDto;
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
    public ResponseEntity<MemberResponseDto> getMember(@LoginMember Member member) {
        return ResponseEntity.ok(memberService.getMember(member));
    }

    @GetMapping("/{email}")
    public ResponseEntity<MemberResponseDto> getMemberProfile(@PathVariable String email) {
        return ResponseEntity.ok(memberService.getMemberByEmail(email));
    }

    // todo put 요청으로 추가 정보 기입하기(role 선택, 회원 설명, deviceuuid, 프로필 사진, 이름 제대로 적혀있는지 확인)
    // todo get 요청으로 자기 팀에 해당하는 모든 팀원 반환

    @DeleteMapping
    public ResponseEntity<Void> deleteMember(@LoginMember Member member) {
        memberService.deleteMember(member);
        return ResponseEntity.noContent().build();
    }
}