package com.example.exam_service;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/exam")
public class ExamController {

    @GetMapping("/schedule")
    public List<String> getSchedule() {
        return List.of("Math - 10 AM", "Science - 2 PM", "History - 4 PM");
    }
}
