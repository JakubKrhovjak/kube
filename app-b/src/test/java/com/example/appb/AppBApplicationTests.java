package com.example.appb;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@SpringBootTest
class AppBApplicationTests {


    @GetMapping("/")
    public String message() {
        return  "Hello App B works!";
    }
}
