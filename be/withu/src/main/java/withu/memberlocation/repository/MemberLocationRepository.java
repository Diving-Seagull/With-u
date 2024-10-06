package withu.memberlocation.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import withu.member.entity.Member;
import withu.memberlocation.entity.MemberLocation;

@Repository
public interface MemberLocationRepository extends JpaRepository<MemberLocation, Long> {

    Optional<MemberLocation> findByMember(Member member);
}
