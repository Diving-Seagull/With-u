package withu.global.validation;

import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.Payload;

import java.lang.annotation.*;
import java.util.Arrays;
import java.util.Locale;

@Documented
@Constraint(validatedBy = LanguageCodeValidator.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidLanguageCode {
    String message() default "Invalid language code";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

class LanguageCodeValidator implements ConstraintValidator<ValidLanguageCode, String> {
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value == null) {
            return true;
        }
        return Arrays.stream(Locale.getISOLanguages()).anyMatch(lang -> lang.equalsIgnoreCase(value))
            || Arrays.stream(Locale.getAvailableLocales())
            .map(Locale::getLanguage)
            .anyMatch(lang -> lang.equalsIgnoreCase(value));
    }
}