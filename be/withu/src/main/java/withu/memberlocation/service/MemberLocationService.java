package withu.memberlocation.service;

import static withu.global.exception.ExceptionCode.*;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import withu.global.exception.CustomException;
import withu.member.entity.Member;
import withu.member.enums.Role;
import withu.member.repository.MemberRepository;
import withu.memberlocation.dto.LocationResponseDto;
import withu.memberlocation.entity.MemberLocation;
import withu.memberlocation.repository.MemberLocationRepository;
import withu.notification.service.NotificationService;

@Service
@RequiredArgsConstructor
public class MemberLocationService {

    private final MemberRepository memberRepository;
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

    public LocationResponseDto getLeaderLocation(Member member) {
        Member leader = memberRepository.findByTeamAndRole(member.getTeam(), Role.LEADER)
            .orElseThrow(() -> new CustomException(USER_NOT_FOUND));

        MemberLocation leaderLocation = memberLocationRepository.findByMember(leader)
            .orElseThrow(() -> new CustomException(MEMBER_LOCATION_NOT_FOUND));

        return LocationResponseDto.from(leaderLocation);
    }

    public LocationResponseDto updateMemberLocation(Member member, Double latitude, Double longitude) {
        if (!member.isLeader()) {
            throw new CustomException(USER_NOT_LEADER);
        }

        MemberLocation memberLocation = memberLocationRepository.findByMember(member)
            .orElse(MemberLocation.builder().member(member).latitude(latitude).longitude(longitude)
                .build());

        memberLocation.updateLocation(latitude, longitude);
        memberLocationRepository.save(memberLocation);

        notificationService.sendLocationUpdateNotificationToTeam(member);

        return LocationResponseDto.from(memberLocation);
    }
}
