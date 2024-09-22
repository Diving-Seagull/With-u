package withu.template.service;

import withu.template.domain.TemplateDomain;
import withu.template.dto.TemplateServiceDto;
import withu.template.exception.TemplateNotFoundException;
import withu.template.repository.TemplateRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TemplateService {
    private final TemplateRepository templateRepository;

    public TemplateService(TemplateRepository templateRepository) {
        this.templateRepository = templateRepository;
    }

    public List<TemplateDomain> getAllTemplateDomains() {
        return templateRepository.findAll();
    }

    public TemplateDomain getTemplateDomainById(Long id) {
        return templateRepository.findById(id)
                .orElseThrow(TemplateNotFoundException::new);
    }

    public TemplateDomain createTemplateDomain(TemplateServiceDto templateCreateServiceDto) {
        return templateRepository.save(templateCreateServiceDto.toTemplateDomain());
    }

    public TemplateDomain updateTemplateDomain(TemplateServiceDto templateCreateServiceDto) {
        validateTemplateDomainExists(templateCreateServiceDto.getId());
        return templateRepository.save(templateCreateServiceDto.toTemplateDomain());
    }

    public void deleteTemplateDomain(Long id) {
        validateTemplateDomainExists(id);
        templateRepository.deleteById(id);
    }

    private void validateTemplateDomainExists(Long id) {
        if (!templateRepository.existsById(id)) {
            throw new TemplateNotFoundException();
        }
    }
}
