package com.example.appb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@SpringBootApplication
public class AppB {

    public static void main(String[] args) {
        SpringApplication.run(AppB.class, args);
    }

    @GetMapping
    public String ok() {
        return "App B works";
    }

}
