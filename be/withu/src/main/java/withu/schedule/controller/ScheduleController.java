package withu.schedule.controller;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import withu.auth.LoginMember;
import withu.member.entity.Member;
import withu.schedule.dto.ScheduleRequestDto;
import withu.schedule.dto.ScheduleResponseDto;
import withu.schedule.dto.ScheduleUpdateDto;
import withu.schedule.service.ScheduleService;

@RestController
@RequestMapping("/api/schedules")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;

    @GetMapping("/morning")
    public ResponseEntity<List<ScheduleResponseDto>> getMorningSchedules(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
        @LoginMember Member member) {
        List<ScheduleResponseDto> schedules = scheduleService.getMorningSchedules(date, member);
        return ResponseEntity.ok(schedules);
    }

    @GetMapping("/afternoon")
    public ResponseEntity<List<ScheduleResponseDto>> getAfternoonSchedules(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
        @LoginMember Member member) {
        List<ScheduleResponseDto> schedules = scheduleService.getAfternoonSchedules(date, member);
        return ResponseEntity.ok(schedules);
    }

    @PostMapping
    public ResponseEntity<ScheduleResponseDto> createSchedule(
        @Valid @RequestBody ScheduleRequestDto requestDto, @LoginMember Member member) {
        ScheduleResponseDto responseDto = scheduleService.createSchedule(requestDto, member);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDto);
    }

    @PutMapping("/{scheduleId}")
    public ResponseEntity<ScheduleResponseDto> updateSchedule(@PathVariable Long scheduleId,
        @Valid @RequestBody ScheduleUpdateDto updateDto, @LoginMember Member member) {
        ScheduleResponseDto updatedSchedule = scheduleService.updateSchedule(scheduleId, updateDto,
            member);
        return ResponseEntity.ok(updatedSchedule);
    }

    @DeleteMapping("/{scheduleId}")
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long scheduleId,
        @LoginMember Member member) {
        scheduleService.deleteSchedule(scheduleId, member);
        return ResponseEntity.noContent().build();
    }
}