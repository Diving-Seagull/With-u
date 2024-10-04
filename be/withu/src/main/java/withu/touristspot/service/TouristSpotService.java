package withu.touristspot.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.touristspot.dto.TouristSpotResponseDto;
import withu.touristspot.entity.TouristSpot;
import withu.touristspot.repository.TouristSpotRepository;

@Service
@RequiredArgsConstructor
public class TouristSpotService {
    private final TouristSpotRepository touristSpotRepository;
    private final GeocodingService geocodingService;

    public List<TouristSpotResponseDto> recommendTouristSpots(Double latitude, Double longitude) {
        String address = geocodingService.getAddressFromCoordinates(latitude, longitude);

        String parsedAddress = parseCityAndDistrict(address);

        List<TouristSpot> spots = touristSpotRepository.findByAddressContaining(parsedAddress);
        return spots.stream()
            .map(touristSpot -> TouristSpotResponseDto.builder()
                .id(touristSpot.getId())
                .name(touristSpot.getName())
                .address(touristSpot.getAddress())
                .description(touristSpot.getDescription())
                .latitude(touristSpot.getLatitude())
                .longitude(touristSpot.getLongitude())
                .category(touristSpot.getCategory())
                .build())
            .collect(Collectors.toList());
    }

    private String parseCityAndDistrict(String fullAddress) {
        String[] addressParts = fullAddress.split("\\s+");

        // 시/광역시 + 지역구 추출
        if (addressParts.length >= 3) {
            return addressParts[1] + " " + addressParts[2];
        }

        // 추출 실패 시 전체 주소 반환
        return fullAddress;
    }
}
