package withu.touristspot.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;
import lombok.Getter;

@Getter
@JsonIgnoreProperties(ignoreUnknown = true)
public class GoogleGeocodingResponseDto {
    private List<Result> results;
    private String status;

    @Getter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Result {
        private String formatted_address;
        private Geometry geometry;
    }

    @Getter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Geometry {
        private Location location;
    }

    @Getter
    public static class Location {
        private double lat;
        private double lng;
    }
}