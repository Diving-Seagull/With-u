package withu.global.handler;

import java.util.Objects;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import withu.global.utils.ApiUtils;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> unknownServerError(Exception e) {
        String message = extractDesiredMessage(e.getMessage());

        ApiUtils.ApiFail apiResult = ApiUtils.fail(message, HttpStatus.INTERNAL_SERVER_ERROR);
        return new ResponseEntity<>(apiResult, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> handleValidationExceptions(MethodArgumentNotValidException ex) {
        BindingResult result = ex.getBindingResult();
        String errorMessage = Objects.requireNonNull(result.getFieldError()).getDefaultMessage();
        return ResponseEntity.badRequest()
            .body(ApiUtils.fail(errorMessage, HttpStatus.BAD_REQUEST));
    }

    // 메시지에서 원하는 부분만 노출 되도록 처리
    private String extractDesiredMessage(String fullMessage) {
        if (fullMessage != null && fullMessage.contains("Required request body is missing")) {
            return "Required request body is missing.";
        }
        return fullMessage;
    }
}