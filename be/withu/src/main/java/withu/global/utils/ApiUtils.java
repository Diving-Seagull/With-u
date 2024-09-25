package withu.global.utils;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;

public class ApiUtils {

    public static <T> ApiSuccess<T> success(T response) {
        return new ApiSuccess<>(response);
    }

    public static ApiFail fail(String message, HttpStatus httpStatus) {
        return new ApiFail(message, httpStatus.value());
    }

    @Getter
    @Setter
    @AllArgsConstructor
    public static class ApiSuccess<T> {

        private final T data;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    public static class ApiFail {

        private final String message;
        private final int errorCode;
    }
}