package withu.global.exception;

import withu.global.response.ErrorCode;

public class AccessTokenNotExistsException extends BusinessException {
    public AccessTokenNotExistsException() {
        super(ErrorCode.ACCESS_TOKEN_NOT_EXISTS_ERROR);
    }
}
