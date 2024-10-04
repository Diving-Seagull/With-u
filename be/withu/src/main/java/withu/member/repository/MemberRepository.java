package withu.member.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import withu.member.entity.Member;
import withu.member.enums.Role;
import withu.team.entity.Team;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {

    boolean existsById(Long id);

    Optional<Member> findByEmail(String email);

    List<Member> findByTeam(Team team);

    Optional<Member> findByTeamAndRole(Team team, Role role);
}
