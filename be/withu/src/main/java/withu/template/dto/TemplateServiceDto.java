package withu.template.dto;

import withu.template.domain.TemplateColumn1;
import withu.template.domain.TemplateColumn2;
import withu.template.domain.TemplateDomain;
import lombok.Getter;

@Getter
public class TemplateServiceDto {
    private Long id;
    private TemplateColumn1 templateColumn1;
    private TemplateColumn2 templateColumn2;

    // 생성자
    public TemplateServiceDto(Long id, TemplateColumn1 templateColumn1, TemplateColumn2 templateColumn2) {
        this.id = id;
        this.templateColumn1 = templateColumn1;
        this.templateColumn2 = templateColumn2;
    }

    // TemplateCreateServiceDto로 변환하는 메서드
    public TemplateDomain toTemplateDomain() {
        return new TemplateDomain(id, templateColumn1, templateColumn2);
    }
}
