package withu.touristspot.dto;

import lombok.Builder;
import lombok.Getter;
import withu.global.utils.TranslationUtil;
import withu.touristspot.entity.TouristSpot;
import withu.touristspot.enums.TouristSpotCategory;

@Getter
@Builder
public class TouristSpotResponseDto {
    private Long id;
    private String name;
    private String address;
    private String description;
    private Double latitude;
    private Double longitude;
    private TouristSpotCategory category;

    public static TouristSpotResponseDto from(TouristSpot touristSpot) {
        return TouristSpotResponseDto.builder()
            .id(touristSpot.getId())
            .name(touristSpot.getName())
            .address(touristSpot.getAddress())
            .description(touristSpot.getDescription())
            .latitude(touristSpot.getLatitude())
            .longitude(touristSpot.getLongitude())
            .category(touristSpot.getCategory())
            .build();
    }

    public void translate(String languageCode, TranslationUtil translationUtil) {
        this.name = translationUtil.translateText(this.name, languageCode);
        this.address = translationUtil.translateText(this.address, languageCode);
        this.description = translationUtil.translateText(this.description, languageCode);
    }
}