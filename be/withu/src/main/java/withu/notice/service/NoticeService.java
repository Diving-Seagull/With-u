package withu.notice.service;

import static withu.global.exception.ExceptionCode.*;

import jakarta.transaction.Transactional;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.global.utils.TranslationUtil;
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
    private final TranslationUtil translationUtil;

    public NoticeResponseDto getNotice(Member member, Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));

        if (!notice.getTeam().equals(member.getTeam())) {
            throw new CustomException(NOTICE_NOT_IN_USER_TEAM);
        }

        return translateNoticeResponse(NoticeResponseDto.from(notice), member.getLanguageCode());
    }

    public List<NoticeResponseDto> getAllNotices(Member member) {
        if (member.getTeam() == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        List<Notice> notices = noticeRepository.findByTeamOrderByCreatedAtDesc(member.getTeam());
        return notices.stream()
            .map(NoticeResponseDto::from)
            .map(dto -> translateNoticeResponse(dto, member.getLanguageCode()))
            .collect(Collectors.toList());
    }

    public Optional<NoticeResponseDto> getPinnedNotice(Member member) {
        if (member.getTeam() == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        return noticeRepository.findFirstByTeamAndPinnedTrueOrderByCreatedAtDesc(member.getTeam())
            .map(NoticeResponseDto::from)
            .map(dto -> translateNoticeResponse(dto, member.getLanguageCode()));
    }

    private NoticeResponseDto translateNoticeResponse(NoticeResponseDto dto, String languageCode) {
        System.out.println("languageCode: " + languageCode);
        String translatedTitle = translationUtil.translateText(dto.getTitle(), languageCode);
        String translatedContent = translationUtil.translateText(dto.getContent(), languageCode);

        return dto.withTranslation(translatedTitle, translatedContent);
    }

    @Transactional
    public NoticeResponseDto createNotice(Member author, NoticeRequestDto requestDto) {
        validateLeaderRole(author);

        Team team = author.getTeam();
        if (team == null) {
            throw new CustomException(MEMBER_NOT_IN_TEAM);
        }

        Notice notice = Notice.builder()
            .team(team)
            .title(requestDto.getTitle())
            .content(requestDto.getContent())
            .author(author)
            .build();

        if (requestDto.getImages() != null && !requestDto.getImages().isEmpty()) {
            for (NoticeRequestDto.ImageDto imageDto : requestDto.getImages()) {
                try {
                    byte[] imageData = Base64.getDecoder().decode(imageDto.getBase64Data());
                    notice.addImage(imageData, imageDto.getContentType());
                } catch (IllegalArgumentException e) {
                    log.error("Error decoding base64 image data", e);
                    throw new CustomException(INVALID_IMAGE_DATA);
                }
            }
        }

        if (requestDto.isPinned()) {
            unpinExistingNotices(team);
            notice.pin();
        }

        Notice savedNotice = noticeRepository.save(notice);

        // Firebase 알림 전송 (이미지 URL 대신 첫 번째 이미지의 ID를 사용)
        List<Member> teamMembers = memberRepository.findByTeam(team);
        Long firstImageId = savedNotice.getImages().isEmpty() ? null : savedNotice.getImages().get(0).getId();

        notificationService.sendNotificationToTeam(
            teamMembers,
            "새로운 공지사항",
            author.getName() + "님이 새 공지사항을 작성했습니다: " + requestDto.getTitle(),
            firstImageId != null ? "/api/notice/image/" + firstImageId : null
        );

        return NoticeResponseDto.from(savedNotice);
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
                        log.warn("Image with id {} not found in notice {}. Skipping removal.", imageId, noticeId);
                    } else {
                        throw e;
                    }
                }
            }
        }

        // Add new images
        if (requestDto.getNewImages() != null && !requestDto.getNewImages().isEmpty()) {
            for (NoticeUpdateRequestDto.ImageDto imageDto : requestDto.getNewImages()) {
                try {
                    byte[] imageData = Base64.getDecoder().decode(imageDto.getBase64Data());
                    notice.addImage(imageData, imageDto.getContentType());
                } catch (CustomException e) {
                    if (e.getExceptionCode() == NOTICE_IMAGE_LIMIT_EXCEEDED) {
                        log.warn("Image limit exceeded for notice {}. Stopping image addition.", noticeId);
                        break;
                    } else {
                        throw e;
                    }
                } catch (IllegalArgumentException e) {
                    log.error("Error decoding base64 image data", e);
                    throw new CustomException(INVALID_IMAGE_DATA);
                }
            }
        }

        Notice updatedNotice = noticeRepository.save(notice);

        // Firebase 알림 전송 (이미지 URL 대신 첫 번째 이미지의 ID를 사용)
        List<Member> teamMembers = memberRepository.findByTeam(notice.getTeam());
        Long firstImageId = updatedNotice.getImages().isEmpty() ? null : updatedNotice.getImages().get(0).getId();

        try {
            notificationService.sendNotificationToTeam(
                teamMembers,
                "공지사항 업데이트",
                member.getName() + "님이 공지사항을 수정했습니다: " + updatedNotice.getTitle(),
                firstImageId != null ? "/api/notice/image/" + firstImageId : null
            );
        } catch (CustomException e) {
            if (e.getExceptionCode() == NOTIFICATION_ERROR) {
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

    @Transactional
    public void unpinExistingNotices(Team team) {
        List<Notice> pinnedNotices = noticeRepository.findByTeamAndPinnedTrue(team);
        if (!pinnedNotices.isEmpty()) {
            pinnedNotices.forEach(Notice::unpin);
            noticeRepository.saveAll(pinnedNotices);
            log.info("Unpinned {} notices for team {}", pinnedNotices.size(), team.getId());
        }
    }
}
