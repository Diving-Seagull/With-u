package withu.memberlocation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.memberlocation.service.MemberLocationService;

@RestController
@RequestMapping("/api/member-location")
@RequiredArgsConstructor
public class MemberLocationController {

    private final MemberLocationService memberLocationService;

    @PutMapping()
    public ResponseEntity<String> updateLocation(@LoginMember Member member, @RequestParam Double latitude, @RequestParam Double longitude {
        memberLocationService.updateMemberLocation(member, latitude, longitude);
        return ResponseEntity.ok("Location updated successfully");
    }
}