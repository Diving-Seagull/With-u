package withu.memberlocation.dto;

import lombok.Builder;
import lombok.Getter;
import withu.memberlocation.entity.MemberLocation;

@Getter
@Builder
public class LocationResponseDto {

    private Long memberId;
    private Double latitude;
    private Double longitude;
    private String message;

    public static LocationResponseDto from(MemberLocation memberLocation) {
        return LocationResponseDto.builder()
            .memberId(memberLocation.getMember().getId())
            .latitude(memberLocation.getLatitude())
            .longitude(memberLocation.getLongitude())
            .message(memberLocation.getMessage())
            .build();
    }
}
