package withu.touristspot.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class GoogleGeocodingResponseDto {
    private List<Result> results;
    private String status;

    @Getter
    @Setter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Result {
        private String formatted_address;
        private Geometry geometry;
    }

    @Getter
    @Setter
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Geometry {
        private Location location;
    }

    @Getter
    @Setter
    public static class Location {
        private double lat;
        private double lng;
    }
}