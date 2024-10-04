package withu.touristspot.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.touristspot.entity.TouristSpot;
import withu.touristspot.repository.TouristSpotRepository;
import withu.touristspot.dto.TouristSpotResponseDto;

@Service
@RequiredArgsConstructor
public class TouristSpotService {
    private final TouristSpotRepository touristSpotRepository;
    private final GeocodingService geocodingService;

    public List<TouristSpotResponseDto> recommendTouristSpots(Double latitude, Double longitude) {
        String address = geocodingService.getAddressFromCoordinates(latitude, longitude);
        System.out.println("address: " + address);

        String parsedAddress = parseCityAndDistrict(address);
        System.out.println("parsed address: " + parsedAddress);

        List<TouristSpot> spots = touristSpotRepository.findByAddressContaining(parsedAddress);
        return spots.stream()
            .map(touristSpot -> TouristSpotResponseDto.builder()
                .id(touristSpot.getId())
                .name(touristSpot.getName())
                .address(touristSpot.getAddress())
                .description(touristSpot.getDescription())
                .latitude(touristSpot.getLatitude())
                .longitude(touristSpot.getLongitude())
                .build())
            .collect(Collectors.toList());
    }

    private String parseCityAndDistrict(String fullAddress) {
        String[] addressParts = fullAddress.split("\\s+");

        // 시/광역시 + 구 추출
        if (addressParts.length >= 3) {
            return addressParts[1] + " " + addressParts[2];
        }

        // 추출 실패 시 전체 주소 반환
        return fullAddress;
    }
}
