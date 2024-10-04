package withu.memberlocation.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.member.entity.Member;
import withu.memberlocation.dto.LocationResponseDto;
import withu.memberlocation.entity.MemberLocation;
import withu.memberlocation.repository.MemberLocationRepository;
import withu.notification.service.NotificationService;

@Service
@RequiredArgsConstructor
public class MemberLocationService {

    private final MemberLocationRepository memberLocationRepository;
    private final NotificationService notificationService;

    public void createInitialLocationForLeader(Member member) {
        MemberLocation memberLocation = MemberLocation.builder()
            .member(member)
            .latitude(null)
            .longitude(null)
            .build();

        memberLocationRepository.save(memberLocation);
    }

    public LocationResponseDto updateMemberLocation(Member member, Double latitude, Double longitude) {
        MemberLocation memberLocation = memberLocationRepository.findByMember(member)
            .orElse(MemberLocation.builder().member(member).latitude(latitude).longitude(longitude)
                .build());

        memberLocation.updateLocation(latitude, longitude);
        memberLocationRepository.save(memberLocation);

        notificationService.sendLocationUpdateNotificationToTeam(member);

        return LocationResponseDto.from(memberLocation);
    }
}
