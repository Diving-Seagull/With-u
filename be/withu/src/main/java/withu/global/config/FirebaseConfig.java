package withu.global.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

@Configuration
public class FirebaseConfig {

    @Value("${firebase.credential.path}")
    private String firebaseCredentialPath;

    @Value("${firebase.database.url}")
    private String firebaseDatabaseUrl;

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        GoogleCredentials credentials = GoogleCredentials.fromStream(
            new ClassPathResource(firebaseCredentialPath).getInputStream());

        FirebaseOptions options = FirebaseOptions.builder()
            .setCredentials(credentials)
            .setDatabaseUrl(firebaseDatabaseUrl)
            .build();

        return FirebaseApp.initializeApp(options);
    }
}