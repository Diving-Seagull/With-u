package withu.global.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@RequiredArgsConstructor
@Getter
public enum ExceptionCode {
    // 사용자 관련 에러
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "해당 사용자를 찾을 수 없습니다."),
    USER_FORBIDDEN(HttpStatus.FORBIDDEN, "권한이 없습니다."),
    USER_EMAIL_ALREADY_EXISTS(HttpStatus.CONFLICT, "이미 존재하는 이메일입니다."),
    TOKEN_EXPIRED(HttpStatus.UNAUTHORIZED, "토큰이 만료되었습니다."),


    // 잘못된 접근
    SOCIAL_TOKEN_MISSING(HttpStatus.BAD_REQUEST, "소셜 토큰이 제공되지 않았습니다."),
    FIREBASE_TOKEN_MISSING(HttpStatus.BAD_REQUEST, "파이어베이스 토큰이 제공되지 않았습니다."),
    BAD_APPROACH(HttpStatus.BAD_REQUEST, "잘못된 접근입니다."),
    NOTICE_NOT_FOUND(HttpStatus.NOT_FOUND, "요청한 공지사항을 찾을 수 없습니다."),
    USER_NOT_LEADER(HttpStatus.FORBIDDEN, "해당 작업은 팀 리더만 수행할 수 있습니다."),
    NOTICE_NOT_IN_USER_TEAM(HttpStatus.FORBIDDEN, "해당 공지사항은 사용자의 팀에 속하지 않습니다."),
    TEAM_CODE_REQUIRED(HttpStatus.BAD_REQUEST, "팀 코드가 제공되지 않았습니다."),
    MEMBER_NOT_IN_TEAM(HttpStatus.BAD_REQUEST, "팀에 소속되지 않은 사용자입니다."),
    TEAM_NOT_FOUND(HttpStatus.NOT_FOUND, "해당 팀을 찾을 수 없습니다."),




    ;


    private final HttpStatus httpStatus;
    private final String message;
}