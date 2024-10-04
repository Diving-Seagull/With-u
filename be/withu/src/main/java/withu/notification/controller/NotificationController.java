package withu.notification.controller;

import jakarta.validation.constraints.Positive;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.notification.dto.NotificationRequestDto;
import withu.notification.service.NotificationService;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/teams/{teamId}/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @PostMapping("/send-alert")
    public ResponseEntity<String> sendTeamAlert(@LoginMember Member member,
        @PathVariable @Positive Long teamId,
        @Valid @RequestBody NotificationRequestDto requestDto) {
        notificationService.sendTeamAlert(teamId, requestDto, member);
        return ResponseEntity.ok("Notifications sent successfully");
    }
}