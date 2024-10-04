package withu.touristspot.service;

public interface GeocodingService {

    String getAddressFromCoordinates(Double latitude, Double longitude);
}