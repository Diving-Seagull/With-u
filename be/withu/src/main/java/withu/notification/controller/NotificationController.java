package withu.notification.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.notification.dto.NotificationRequestDto;
import withu.notification.service.NotificationService;

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