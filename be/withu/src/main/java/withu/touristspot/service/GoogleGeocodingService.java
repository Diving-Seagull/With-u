package withu.touristspot.service;

import static withu.global.exception.ExceptionCode.ADDRESS_NOT_FOUND;
import static withu.global.exception.ExceptionCode.GEOCODING_API_ERROR;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import withu.global.exception.CustomException;
import withu.touristspot.dto.GoogleGeocodingResponseDto;

@Service
public class GoogleGeocodingService implements GeocodingService {
    private final RestTemplate restTemplate;
    private final String apiKey;
    private final String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json";

    @Autowired
    public GoogleGeocodingService(RestTemplate restTemplate, @Value("${google.geocoding.api-key}") String apiKey) {
        this.restTemplate = restTemplate;
        this.apiKey = apiKey;
    }

    @Override
    public String getAddressFromCoordinates(Double latitude, Double longitude) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(apiUrl)
            .queryParam("latlng", latitude + "," + longitude)
            .queryParam("key", apiKey)
            .queryParam("language", "ko");

        String url = builder.toUriString();

        try {
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            ObjectMapper mapper = new ObjectMapper();
            GoogleGeocodingResponseDto responseDto = mapper.readValue(response.getBody(), GoogleGeocodingResponseDto.class);

            if (responseDto != null && responseDto.getResults() != null && !responseDto.getResults().isEmpty()) {
                return responseDto.getResults().get(0).getFormatted_address();
            } else {
                throw new CustomException(ADDRESS_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new CustomException(GEOCODING_API_ERROR);
        }
    }
}
