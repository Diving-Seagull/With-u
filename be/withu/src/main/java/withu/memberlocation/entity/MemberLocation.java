package withu.memberlocation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import withu.member.entity.Member;

@Entity
@Table(name = "member_locations")
@Getter
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class MemberLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(nullable = true)
    private Double latitude;

    @Column(nullable = true)
    private Double longitude;

    @Column(length = 500)
    private String message;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @Builder
    public MemberLocation(Member member, Double latitude, Double longitude, String message) {
        this.member = member;
        this.latitude = latitude;
        this.longitude = longitude;
        this.message = message;
    }

    public void updateLocation(Double latitude, Double longitude, String message) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.message = message;
    }
}
