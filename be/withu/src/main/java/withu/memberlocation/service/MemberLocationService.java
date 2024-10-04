package withu.memberlocation.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.member.entity.Member;
import withu.memberlocation.entity.MemberLocation;
import withu.memberlocation.repository.MemberLocationRepository;

@Service
@RequiredArgsConstructor
public class MemberLocationService {

    private final MemberLocationRepository memberLocationRepository;

    public void createInitialLocationForLeader(Member member) {
        MemberLocation memberLocation = MemberLocation.builder()
            .member(member)
            .latitude(null)
            .longitude(null)
            .build();

        memberLocationRepository.save(memberLocation);
    }

    public void updateMemberLocation(Member member, Double latitude, Double longitude) {
        MemberLocation memberLocation = memberLocationRepository.findByMember(member)
            .orElse(MemberLocation.builder().member(member).latitude(latitude).longitude(longitude)
                .build());

        memberLocation.updateLocation(latitude, longitude);
        memberLocationRepository.save(memberLocation);

        // Firebase 알림을 보내는 로직 추가 가능
        // firebaseService.sendLocationUpdateNotification(member.getFirebaseToken(), latitude, longitude);
    }
}
