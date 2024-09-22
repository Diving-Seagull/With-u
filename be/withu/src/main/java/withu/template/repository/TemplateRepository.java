package withu.template.repository;

import withu.global.MyCrudRepository;
import withu.template.domain.TemplateDomain;

public interface TemplateRepository extends MyCrudRepository<TemplateDomain, Long> {
    boolean existsById(Long id);
}
