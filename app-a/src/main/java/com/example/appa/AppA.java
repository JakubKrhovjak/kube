package com.example.appa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@SpringBootApplication
public class AppA {

	public static void main(String[] args) {
		SpringApplication.run(AppA.class, args);
	}

	@GetMapping("/")
	public String message() {
		return  "Hello App A works!";
	}

}
