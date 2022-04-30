package com.example.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping
@SpringBootApplication
public class GatewayApplication {

    @RequestMapping
    public String get() {
        return "Gateway";
    }

    public static void main(String[] args) {
        SpringApplication.run(GatewayApplication.class, args);
    }


    @Bean
    public RouteLocator gatewayRoutes(RouteLocatorBuilder builder) {
        return builder.routes()
            .route(r -> r.path("/appa/**")
                .uri("http://localhost:8081/"))

//                .id("appa"))

            .route(r -> r.path("/appb/**")
                .uri("http://localhost:8082/"))
//                .id("appb"))
            .build();
    }

}
