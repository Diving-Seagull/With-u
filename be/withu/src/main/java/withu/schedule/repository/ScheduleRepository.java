package withu.schedule.repository;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import withu.member.entity.Member;
import withu.schedule.entity.Schedule;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    @Query("SELECT s FROM Schedule s WHERE s.member = :member AND " +
        "((s.startTime BETWEEN :start AND :end) OR " +
        "(s.endTime BETWEEN :start AND :end) OR " +
        "(s.startTime <= :start AND s.endTime >= :end))")
    List<Schedule> findByMemberAndTimeBetween(@Param("member") Member member,
        @Param("start") LocalDateTime start,
        @Param("end") LocalDateTime end);
}