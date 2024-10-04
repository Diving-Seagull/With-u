package withu.notice.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import withu.notice.entity.Notice;
import withu.team.entity.Team;

@Repository
public interface NoticeRepository extends JpaRepository<Notice, Long> {

    List<Notice> findByTeamOrderByCreatedAtDesc(Team team);

    List<Notice> findByTeamAndPinnedTrue(Team team);

    Optional<Notice> findFirstByTeamAndPinnedTrueOrderByCreatedAtDesc(Team team);
}
