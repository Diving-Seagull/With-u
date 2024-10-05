package withu.notice.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "notice_images")
@Getter
@NoArgsConstructor(access = lombok.AccessLevel.PROTECTED)
public class NoticeImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "notice_id", nullable = false)
    private Notice notice;

    @Column(nullable = false)
    private String imageUrl;

    @Column(name = "image_order", nullable = false)
    private int order;

    public NoticeImage(Notice notice, String imageUrl, int order) {
        this.notice = notice;
        this.imageUrl = imageUrl;
        this.order = order;
    }

    public void updateOrder(int newOrder) {
        this.order = newOrder;
    }
}