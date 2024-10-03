package withu.notification.service;

import com.google.firebase.messaging.AndroidNotification;
import com.google.firebase.messaging.ApnsConfig;
import com.google.firebase.messaging.Aps;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.stereotype.Service;
import withu.member.entity.Member;

import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseService {

    public void sendNotificationToTeam(List<Member> teamMembers, String title, String body) {
        teamMembers.forEach(member -> {
            if (member.getFirebaseToken() != null) {
                Message message = Message.builder()
                    .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                    .setToken(member.getFirebaseToken())
                    .setAndroidConfig(com.google.firebase.messaging.AndroidConfig.builder()
                        .setNotification(AndroidNotification.builder()
                            .setSound("default")
                            .build())
                        .build())
                    .setApnsConfig(ApnsConfig.builder()
                        .setAps(Aps.builder()
                            .setSound("default")
                            .build())
                        .build())
                    .build();

                try {
                    String response = FirebaseMessaging.getInstance().sendAsync(message).get();
                    System.out.println("Successfully sent message: " + response);
                } catch (InterruptedException | ExecutionException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}