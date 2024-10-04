package withu.notification.service;

import static withu.global.exception.ExceptionCode.*;

import com.google.firebase.messaging.*;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.member.repository.MemberRepository;
import withu.notification.dto.NotificationRequestDto;
import withu.team.entity.Team;
import withu.team.repository.TeamRepository;

import java.util.List;
import java.util.concurrent.ExecutionException;
import withu.team.service.TeamService;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final MemberRepository memberRepository;
    private final TeamRepository teamRepository;
    private final TeamService teamService;

    public void sendTeamAlert(NotificationRequestDto requestDto, Member sender) {
        // 팀장 권한 확인
        if (!sender.isLeader()) {
            throw new CustomException(NOT_TEAM_LEADER);
        }

        Team team = teamRepository.findById(requestDto.getTeamId())
            .orElseThrow(() -> new CustomException(TEAM_NOT_FOUND));

        // 팀장이 속한 팀과 요청된 팀 ID가 일치하는지 확인
        if (!sender.getTeam().getId().equals(team.getId())) {
            throw new CustomException(TEAM_MISMATCH);
        }

        List<Member> targetMembers = memberRepository.findAllById(requestDto.getTargetMemberIds());

        // 대상 멤버들이 모두 같은 팀에 속해 있는지 확인
        if (targetMembers.stream().anyMatch(member -> !member.getTeam().getId().equals(team.getId()))) {
            throw new CustomException(INVALID_TEAM_MEMBERS);
        }

        String title = "팀 알림";
        String body = sender.getName() + " 팀장이 당신을 찾고 있습니다. 앱에 접속해 주세요.";

        sendNotificationToTeam(targetMembers, title, body, null);
    }

    public void sendNotificationToTeam(List<Member> teamMembers, String title, String body, String imageUrl) {
        teamMembers.forEach(member -> {
            if (member.getFirebaseToken() != null) {
                sendNotification(member, title, body, imageUrl);
            }
        });
    }

    private void sendNotification(Member member, String title, String body, String imageUrl) {
        Message.Builder messageBuilder = Message.builder()
            .setToken(member.getFirebaseToken());

        Notification.Builder notificationBuilder = Notification.builder()
            .setTitle(title)
            .setBody(body);

        AndroidNotification.Builder androidNotificationBuilder = AndroidNotification.builder()
            .setSound("default");

        ApnsConfig.Builder apnsConfigBuilder = ApnsConfig.builder()
            .setAps(Aps.builder().setSound("default").build());

        if (imageUrl != null && !imageUrl.isEmpty()) {
            notificationBuilder.setImage(imageUrl);
            androidNotificationBuilder.setImage(imageUrl);
            apnsConfigBuilder.putCustomData("image", imageUrl);
        }

        messageBuilder.setNotification(notificationBuilder.build())
            .setAndroidConfig(AndroidConfig.builder()
                .setNotification(androidNotificationBuilder.build())
                .build())
            .setApnsConfig(apnsConfigBuilder.build());

        Message message = messageBuilder.build();

        try {
            String response = FirebaseMessaging.getInstance().sendAsync(message).get();
            System.out.println("Successfully sent message to " + member.getName() + ": " + response);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new CustomException(NOTIFICATION_ERROR);
        } catch (ExecutionException e) {
            throw new CustomException(NOTIFICATION_ERROR);
        }
    }
}