package withu.notice.service;

import static withu.global.exception.ExceptionCode.MEMBER_NOT_IN_TEAM;
import static withu.global.exception.ExceptionCode.NOTICE_IMAGE_LIMIT_EXCEEDED;
import static withu.global.exception.ExceptionCode.NOTICE_IMAGE_NOT_FOUND;
import static withu.global.exception.ExceptionCode.NOTICE_NOT_FOUND;
import static withu.global.exception.ExceptionCode.NOTICE_NOT_IN_USER_TEAM;
import static withu.global.exception.ExceptionCode.NOTIFICATION_ERROR;
import static withu.global.exception.ExceptionCode.USER_NOT_LEADER;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.member.enums.Role;
import withu.member.repository.MemberRepository;
import withu.notice.dto.NoticeRequestDto;
import withu.notice.dto.NoticeResponseDto;
import withu.notice.dto.NoticeUpdateRequestDto;
import withu.notice.entity.Notice;
import withu.notice.repository.NoticeRepository;
import withu.notification.service.NotificationService;
import withu.team.entity.Team;

@Slf4j
@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeRepository noticeRepository;
    private final MemberRepository memberRepository;
    private final NotificationService notificationService;

    public NoticeResponseDto getNotice(Member member, Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));

        if (!notice.getTeam().equals(member.getTeam())) {
            throw new CustomException(NOTICE_NOT_IN_USER_TEAM);
        }

        return NoticeResponseDto.from(notice);
    }

    public List<NoticeResponseDto> getAllNotices(Member member) {
        if (member.getTeam() == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        List<Notice> notices = noticeRepository.findByTeamOrderByCreatedAtDesc(member.getTeam());
        return notices.stream()
            .map(NoticeResponseDto::from)
            .collect(Collectors.toList());
    }

    public Optional<NoticeResponseDto> getPinnedNotice(Member member) {
        if (member.getTeam() == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        return noticeRepository.findFirstByTeamAndPinnedTrueOrderByCreatedAtDesc(member.getTeam())
            .map(NoticeResponseDto::from);
    }

    @Transactional
    public NoticeResponseDto createNotice(Member author, NoticeRequestDto requestDto) {
        validateLeaderRole(author);

        Team team = author.getTeam();
        if (team == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        Notice notice = requestDto.toEntity(author);

        if (requestDto.isPinned()) {
            unpinExistingNotices(team);
            notice.pin();
        }

        Notice savedNotice = noticeRepository.save(notice);

        // Firebase 알림 전송
        List<Member> teamMembers = memberRepository.findByTeam(team);
        String imageUrl = (requestDto.getImageUrls() != null && !requestDto.getImageUrls().isEmpty())
            ? requestDto.getImageUrls().get(0)
            : "";

        notificationService.sendNotificationToTeam(
            teamMembers,
            "새로운 공지사항",
            author.getName() + "님이 새 공지사항을 작성했습니다: " + requestDto.getTitle(),
            imageUrl
        );

        return NoticeResponseDto.from(savedNotice);
    }

    private void unpinExistingNotices(Team team) {
        List<Notice> pinnedNotices = noticeRepository.findByTeamAndPinnedTrue(team);
        pinnedNotices.forEach(Notice::unpin);
        noticeRepository.saveAll(pinnedNotices);
    }

    @Transactional
    public NoticeResponseDto updateNotice(Member member, Long noticeId, NoticeUpdateRequestDto requestDto) {
        validateLeaderRole(member);

        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));

        if (!notice.getTeam().equals(member.getTeam())) {
            throw new CustomException(NOTICE_NOT_IN_USER_TEAM);
        }

        notice.update(requestDto.getTitle(), requestDto.getContent());

        // Remove images
        if (requestDto.getImageIdsToRemove() != null && !requestDto.getImageIdsToRemove().isEmpty()) {
            for (Long imageId : requestDto.getImageIdsToRemove()) {
                try {
                    notice.removeImage(imageId);
                } catch (CustomException e) {
                    if (e.getExceptionCode() == NOTICE_IMAGE_NOT_FOUND) {
                        // 로그를 남기고 계속 진행
                        log.warn("Image with id {} not found in notice {}. Skipping removal.", imageId, noticeId);
                    } else {
                        throw e;
                    }
                }
            }
        }

        // Add new images
        if (requestDto.getNewImageUrls() != null && !requestDto.getNewImageUrls().isEmpty()) {
            for (String imageUrl : requestDto.getNewImageUrls()) {
                try {
                    notice.addImage(imageUrl);
                } catch (CustomException e) {
                    if (e.getExceptionCode() == NOTICE_IMAGE_LIMIT_EXCEEDED) {
                        // 이미지 제한에 도달했을 때 처리
                        log.warn("Image limit exceeded for notice {}. Stopping image addition.", noticeId);
                        break;
                    } else {
                        throw e;
                    }
                }
            }
        }

        Notice updatedNotice = noticeRepository.save(notice);

        // Firebase 알림 전송
        List<Member> teamMembers = memberRepository.findByTeam(notice.getTeam());
        String imageUrl = updatedNotice.getImages().isEmpty() ? "" : updatedNotice.getImages().get(0).getImageUrl();

        try {
            notificationService.sendNotificationToTeam(
                teamMembers,
                "공지사항 업데이트",
                member.getName() + "님이 공지사항을 수정했습니다: " + updatedNotice.getTitle(),
                imageUrl
            );
        } catch (CustomException e) {
            if (e.getExceptionCode() == NOTIFICATION_ERROR) {
                // 알림 전송 실패를 로그로 남기고 계속 진행
                log.error("Failed to send Firebase notification for updated notice: {}", e.getMessage());
            } else {
                throw e;
            }
        }

        return NoticeResponseDto.from(updatedNotice);
    }

    @Transactional
    public void deleteNotice(Member member, Long noticeId) {
        validateLeaderRole(member);

        Notice notice = getNoticeById(noticeId);

        if (!notice.getTeam().equals(member.getTeam())) {
            throw new CustomException(NOTICE_NOT_IN_USER_TEAM);
        }

        if (!notice.getAuthor().equals(member)) {
            throw new CustomException(USER_NOT_LEADER);
        }

        noticeRepository.delete(notice);
    }

    private void validateLeaderRole(Member member) {
        if (member.getRole() != Role.LEADER) {
            throw new CustomException(USER_NOT_LEADER);
        }
    }

    private Notice getNoticeById(Long noticeId) {
        return noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));
    }
}
