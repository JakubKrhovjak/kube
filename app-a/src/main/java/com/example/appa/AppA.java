package com.example.appa;

import javax.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;


@RestController
@SpringBootApplication
public class AppA {

	public static void main(String[] args) {
		SpringApplication.run(AppA.class, args);
	}

//
//	@Value("${appb-url}")
//    private String appbUrl;

	@PostConstruct
	public void init() {
		var all = repository.findAll();
		if(all.isEmpty()) {
			repository.save(new Item().setId(1L).setName("name"));
		}
	}

	@Autowired
	private ItemRepository repository;

	@GetMapping("/appa")
	public String message() {
//		RestTemplate restTemplate = new RestTemplate();
//		var b = restTemplate.getForObject(appbUrl + "/appb", String.class);

		return  "Hello App A works! with value: " + repository.findById(1L).get().getName();
	}

}
