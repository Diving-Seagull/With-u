package withu.touristspot.dto;

import lombok.Builder;
import lombok.Getter;
import withu.touristspot.entity.TouristSpot;

@Getter
@Builder
public class TouristSpotResponseDto {
    private Long id;
    private String name;
    private String address;
    private String description;
    private Double latitude;
    private Double longitude;

    public static TouristSpotResponseDto from(TouristSpot touristSpot) {
        return TouristSpotResponseDto.builder()
            .id(touristSpot.getId())
            .name(touristSpot.getName())
            .address(touristSpot.getAddress())
            .description(touristSpot.getDescription())
            .latitude(touristSpot.getLatitude())
            .longitude(touristSpot.getLongitude())
            .build();
    }
}