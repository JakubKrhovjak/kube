package com.example.appa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@SpringBootApplication
public class AppA {

	@Autowired
	private ItemRepository repository;

	public static void main(String[] args) {
		SpringApplication.run(AppA.class, args);
	}

	@GetMapping("/appa")
	public String message() {
		return  "Hello App A works! with value " + repository.findById(1L).get().getName();
	}

}
