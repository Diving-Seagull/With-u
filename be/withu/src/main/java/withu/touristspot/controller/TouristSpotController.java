package withu.touristspot.controller;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.touristspot.dto.TouristSpotResponseDto;
import withu.touristspot.service.TouristSpotService;

@RestController
@RequestMapping("/api/tourist-spots")
@RequiredArgsConstructor
public class TouristSpotController {

    private final TouristSpotService touristSpotService;

    @GetMapping
    public ResponseEntity<List<TouristSpotResponseDto>> recommendTouristSpots(
        @LoginMember Member member, @RequestParam Double latitude, @RequestParam Double longitude) {
        List<TouristSpotResponseDto> recommendations = touristSpotService.recommendTouristSpots(
            latitude, longitude, member.getLanguageCode());
        return ResponseEntity.ok(recommendations);
    }

    @PostMapping
    public ResponseEntity<String> uploadTours(@RequestParam("file") MultipartFile file) {
        touristSpotService.saveToursFromCsv(file);
        return ResponseEntity.ok("CSV file successfully processed and saved.");
    }
}