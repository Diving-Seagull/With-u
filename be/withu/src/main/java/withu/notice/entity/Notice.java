package withu.notice.entity;

import static withu.global.exception.ExceptionCode.*;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.team.entity.Team;

@Entity
@Table(name = "notices")
@Getter
@NoArgsConstructor(access = lombok.AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Notice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false)
    private Team team;

    @Column(nullable = false, length = 100)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", nullable = false)
    private Member author;

    @OneToMany(mappedBy = "notice", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("order ASC")
    private List<NoticeImage> images = new ArrayList<>();

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @Column(nullable = false)
    private boolean pinned = false;

    @Builder
    private Notice(Team team, String title, String content, Member author) {
        this.team = team;
        this.title = title;
        this.content = content;
        this.author = author;
    }

    public void update(String title, String content) {
        this.title = title;
        this.content = content;
    }

    public void addImage(byte[] imageData, String contentType) {
        if (this.images == null) {
            this.images = new ArrayList<>();
        }
        if (this.images.size() >= 5) {
            throw new CustomException(NOTICE_IMAGE_LIMIT_EXCEEDED);
        }
        int newOrder = this.images.isEmpty() ? 0 : this.images.stream()
            .mapToInt(NoticeImage::getOrder)
            .max()
            .orElse(-1) + 1;
        this.images.add(new NoticeImage(this, imageData, contentType, newOrder));
    }

    public void removeImage(NoticeImage image) {
        this.images.remove(image);
        reorderImages();
    }

    public void removeImage(Long imageId) {
        if (this.images == null || this.images.isEmpty()) {
            throw new CustomException(NOTICE_IMAGE_NOT_FOUND);
        }
        boolean removed = this.images.removeIf(img -> img.getId().equals(imageId));
        if (!removed) {
            throw new CustomException(NOTICE_IMAGE_NOT_FOUND);
        }
        reorderImages();
    }

    private void reorderImages() {
        for (int i = 0; i < this.images.size(); i++) {
            this.images.get(i).updateOrder(i);
        }
    }

    public void updateImageOrder(Long imageId, int newOrder) {
        if (newOrder < 0 || newOrder >= this.images.size()) {
            throw new CustomException(NOTICE_IMAGE_COUNT_INVALID);
        }
        NoticeImage imageToMove = this.images.stream()
            .filter(img -> img.getId().equals(imageId))
            .findFirst()
            .orElseThrow(() -> new CustomException(NOTICE_IMAGE_NOT_FOUND));
        this.images.remove(imageToMove);
        this.images.add(newOrder, imageToMove);
        reorderImages();
    }

    public void pin() {
        this.pinned = true;
    }

    public void unpin() {
        this.pinned = false;
    }
}