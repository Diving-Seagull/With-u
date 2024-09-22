package withu.template.exception;

import withu.global.exception.BusinessException;
import withu.global.response.ErrorCode;

public class TemplateNotFoundException extends BusinessException {
    public TemplateNotFoundException() {
        super(ErrorCode.TEMPLATE_NOT_FOUND_ERROR);
    }
}
