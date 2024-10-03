package withu.schedule.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import withu.schedule.entity.Schedule;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

}