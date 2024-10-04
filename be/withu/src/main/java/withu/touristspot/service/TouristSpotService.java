package withu.touristspot.service;

import static withu.global.exception.ExceptionCode.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import withu.global.exception.CustomException;
import withu.touristspot.dto.TouristSpotResponseDto;
import withu.touristspot.entity.TouristSpot;
import withu.touristspot.enums.TouristSpotCategory;
import withu.touristspot.repository.TouristSpotRepository;

@Slf4j
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

    public void saveToursFromCsv(MultipartFile file) {
        List<TouristSpot> touristSpots = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            // BOM 제거
            reader.mark(1);
            if (reader.read() != 0xFEFF) {
                reader.reset();
            }

            // 파일의 첫 몇 줄을 로그로 출력
            log.info("File content (first few lines):");
            for (int i = 0; i < 5; i++) {
                String line = reader.readLine();
                if (line == null) break;
                log.info(line);
            }
            reader.reset();  // 파일 포인터를 다시 처음으로

            // 첫 줄(헤더)을 읽고 처리
            String headerLine = reader.readLine();
            if (headerLine != null) {
                headerLine = headerLine.replaceAll("^\uFEFF", ""); // BOM 제거
                headerLine = headerLine.replaceAll(",$", ""); // 줄 끝의 쉼표 제거
            }
            log.info("Processed header: {}", headerLine);

            // CSV 파일 파서 설정
            CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT
                .withHeader(headerLine.split(","))
                .withIgnoreEmptyLines()
                .withTrim()
                .withIgnoreSurroundingSpaces());

            log.info("CSV Headers: {}", csvParser.getHeaderMap());

            for (CSVRecord csvRecord : csvParser) {
                try {
                    // CSV의 각 레코드를 TouristSpot 객체로 변환
                    TouristSpot touristSpot = TouristSpot.builder()
                        .category(TouristSpotCategory.valueOf(csvRecord.get("category").trim()))
                        .name(csvRecord.get("name").trim())
                        .address(csvRecord.get("address").trim())
                        .latitude(Double.parseDouble(csvRecord.get("latitude").trim()))
                        .longitude(Double.parseDouble(csvRecord.get("longitude").trim()))
                        .description(csvRecord.get("description").trim())
                        .build();

                    touristSpots.add(touristSpot);
                    log.info("Parsed tourist spot: {}", touristSpot);
                } catch (Exception e) {
                    log.error("Error parsing record: {}", csvRecord, e);
                    throw new CustomException(CSV_PARSING_ERROR);
                }
            }
        } catch (IOException e) {
            log.error("Error reading CSV file", e);
            throw new CustomException(CSV_FILE_ERROR);
        }

        try {
            touristSpotRepository.saveAll(touristSpots);
            log.info("Saved {} tourist spots to database", touristSpots.size());
        } catch (Exception e) {
            log.error("Error saving tourist spots to database", e);
            throw new CustomException(CSV_SAVE_ERROR);
        }
    }
}
