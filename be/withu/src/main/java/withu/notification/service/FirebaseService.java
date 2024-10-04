package withu.notification.service;

import static withu.global.exception.ExceptionCode.FIREBASE_NOTIFICATION_ERROR;

import com.google.firebase.messaging.*;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.entity.Member;

import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseService {

    public void sendNotificationToTeam(List<Member> teamMembers, String title, String body, String imageUrl) {
        teamMembers.forEach(member -> {
            if (member.getFirebaseToken() != null) {
                Message.Builder messageBuilder = Message.builder()
                    .setToken(member.getFirebaseToken());

                Notification.Builder notificationBuilder = Notification.builder()
                    .setTitle(title)
                    .setBody(body);

                AndroidNotification.Builder androidNotificationBuilder = AndroidNotification.builder()
                    .setSound("default");

                ApnsConfig.Builder apnsConfigBuilder = ApnsConfig.builder()
                    .setAps(Aps.builder().setSound("default").build());

                // 이미지 URL이 비어있지 않은 경우에만 이미지 설정
                if (!imageUrl.isEmpty()) {
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
                    System.out.println("Successfully sent message: " + response);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new CustomException(FIREBASE_NOTIFICATION_ERROR);
                } catch (ExecutionException e) {
                    throw new CustomException(FIREBASE_NOTIFICATION_ERROR);
                }
            }
        });
    }
}