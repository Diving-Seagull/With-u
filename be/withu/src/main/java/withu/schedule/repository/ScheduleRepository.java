package withu.schedule.repository;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import withu.member.entity.Member;
import withu.schedule.entity.Schedule;
import withu.team.entity.Team;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    @Query("SELECT s FROM Schedule s WHERE s.member = :member AND " +
        "((s.startTime BETWEEN :start AND :end) OR " +
        "(s.endTime BETWEEN :start AND :end) OR " +
        "(s.startTime <= :start AND s.endTime >= :end))")
    List<Schedule> findByMemberAndTimeBetween(@Param("member") Member member,
        @Param("start") LocalDateTime start,
        @Param("end") LocalDateTime end);

    @Query("SELECT s FROM Schedule s WHERE s.member = :member " +
        "AND s.type = 'PERSONAL' " +
        "AND ((s.startTime <= :endTime AND s.endTime >= :startTime) " +
        "OR (s.startTime >= :startTime AND s.startTime < :endTime) " +
        "OR (s.endTime > :startTime AND s.endTime <= :endTime))")
    List<Schedule> findConflictingSchedules(@Param("member") Member member,
        @Param("startTime") LocalDateTime startTime,
        @Param("endTime") LocalDateTime endTime);

    @Query("SELECT s FROM Schedule s WHERE s.team = :team " +
        "AND s.type = 'TEAM' " +
        "AND ((s.startTime <= :endTime AND s.endTime >= :startTime) " +
        "OR (s.startTime >= :startTime AND s.startTime < :endTime) " +
        "OR (s.endTime > :startTime AND s.endTime <= :endTime))")
    List<Schedule> findConflictingTeamSchedules(@Param("team") Team team,
        @Param("startTime") LocalDateTime startTime,
        @Param("endTime") LocalDateTime endTime);
}