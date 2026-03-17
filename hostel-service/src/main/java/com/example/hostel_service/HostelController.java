package com.example.hostel_service;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/hostel")
public class HostelController {

    @GetMapping("/students")
    public List<String> getStudents() {
        return List.of("John Doe", "Jane Smith", "Alice Johnson");
    }
}
