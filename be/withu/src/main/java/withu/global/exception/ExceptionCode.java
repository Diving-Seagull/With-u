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



    // 잘못된 접근
    BAD_APPROACH(HttpStatus.BAD_REQUEST, "잘못된 접근입니다."),
    NOT_USERS_STUDY(HttpStatus.FORBIDDEN, "사용자의 공부 기록이 아닙니다."),
    NOT_USERS_TODO(HttpStatus.FORBIDDEN, "사용자의 TODO 기록이 아닙니다."),
    DUPLICATE_TODO_TITLE(HttpStatus.CONFLICT, "이미 같은 제목의 Todo가 존재합니다."),
    NO_TODO(HttpStatus.NOT_FOUND, "해당 TODO가 존재하지 않습니다.");



    private final HttpStatus httpStatus;
    private final String message;
}