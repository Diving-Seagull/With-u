package withu.notice.controller;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.notice.dto.NoticeRequestDto;
import withu.notice.dto.NoticeResponseDto;
import withu.notice.dto.NoticeUpdateRequestDto;
import withu.notice.service.NoticeService;

@RestController
@RequestMapping("/api/notice")
public class NoticeController {

    private final NoticeService noticeService;

    public NoticeController(NoticeService noticeService) {
        this.noticeService = noticeService;
    }

    @GetMapping("/{noticeId}")
    public ResponseEntity<NoticeResponseDto> getNotice(@LoginMember Member member,
        @PathVariable Long noticeId) {
        return ResponseEntity.ok(noticeService.getNotice(member, noticeId));
    }

    @GetMapping()
    public ResponseEntity<List<NoticeResponseDto>> getAllNotices(@LoginMember Member member) {
        return ResponseEntity.ok(noticeService.getAllNotices(member));
    }


    @PostMapping
    public ResponseEntity<NoticeResponseDto> createNotice(@LoginMember Member member,
        @Valid @RequestBody NoticeRequestDto requestDto) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(noticeService.createNotice(member, requestDto));
    }

    @PutMapping("/{noticeId}")
    public ResponseEntity<NoticeResponseDto> updateNotice(@LoginMember Member member,
        @PathVariable Long noticeId, @Valid @RequestBody NoticeUpdateRequestDto requestDto) {
        return ResponseEntity.ok(noticeService.updateNotice(member, noticeId, requestDto));
    }

    @DeleteMapping("/{noticeId}")
    public ResponseEntity<Void> deleteNotice(@LoginMember Member member,
        @PathVariable Long noticeId) {
        noticeService.deleteNotice(member, noticeId);
        return ResponseEntity.noContent().build();
    }
}