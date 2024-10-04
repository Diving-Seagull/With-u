package withu.touristspot.controller;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import withu.touristspot.dto.TouristSpotResponseDto;
import withu.touristspot.service.TouristSpotService;

@RestController
@RequestMapping("/api/tourist-spots")
@RequiredArgsConstructor
public class TouristSpotController {

    private final TouristSpotService touristSpotService;

    @GetMapping("/recommend")
    public ResponseEntity<List<TouristSpotResponseDto>> recommendTouristSpots(@RequestParam Double latitude,
        @RequestParam Double longitude) {
        List<TouristSpotResponseDto> recommendations = touristSpotService.recommendTouristSpots(latitude,
            longitude);
        return ResponseEntity.ok(recommendations);
    }
}