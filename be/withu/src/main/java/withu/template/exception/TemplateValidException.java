package withu.template.exception;

import withu.global.exception.DomainValidationException;
import withu.global.response.ErrorCode;

public class TemplateValidException extends DomainValidationException {
    public TemplateValidException(ErrorCode errorCode) {
        super(errorCode);
    }
}
