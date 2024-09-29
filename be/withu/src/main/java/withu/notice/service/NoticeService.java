package withu.notice.service;

import static withu.global.exception.ExceptionCode.DELETED_NOTICE;
import static withu.global.exception.ExceptionCode.NOTICE_NOT_FOUND;
import static withu.global.exception.ExceptionCode.NOTICE_NOT_IN_USER_TEAM;
import static withu.global.exception.ExceptionCode.USER_NOT_LEADER;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.member.enums.Role;
import withu.notice.dto.NoticeRequestDto;
import withu.notice.dto.NoticeResponseDto;
import withu.notice.entity.Notice;
import withu.notice.repository.NoticeRepository;
import withu.team.entity.Team;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeRepository noticeRepository;

    public NoticeResponseDto getNotice(Member member, Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));

        if (!notice.isActive()) {
            throw new CustomException(DELETED_NOTICE);
        }
        if (!notice.getTeam().equals(member.getTeam())) {
            throw new CustomException(NOTICE_NOT_IN_USER_TEAM);
        }

        return NoticeResponseDto.from(notice);
    }

    @Transactional
    public NoticeResponseDto createNotice(Member author, NoticeRequestDto requestDto) {
        validateLeaderRole(author);

        Team team = author.getTeam();

        Notice notice = Notice.builder()
            .team(team)
            .title(requestDto.getTitle())
            .content(requestDto.getContent())
            .author(author)
            .build();

        Notice savedNotice = noticeRepository.save(notice);
        return NoticeResponseDto.from(savedNotice);
    }

    @Transactional
    public NoticeResponseDto updateNotice(Member member, Long noticeId, NoticeRequestDto requestDto) {
        validateLeaderRole(member);

        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new CustomException(NOTICE_NOT_FOUND));

        notice.update(requestDto.getTitle(), requestDto.getContent());
        return NoticeResponseDto.from(notice);
    }

    @Transactional
    public void deleteNotice(Member member, Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
            .orElseThrow(() -> new EntityNotFoundException("Notice not found with id: " + noticeId));

        if (!notice.getAuthor().equals(member)) {
            throw new IllegalStateException("You don't have permission to delete this notice");
        }

        notice.deactivate();
    }

    private void validateLeaderRole(Member member) {
        if (member.getRole() != Role.LEADER) {
            throw new CustomException(USER_NOT_LEADER);
        }
    }
}
