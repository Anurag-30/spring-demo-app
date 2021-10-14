package com.devopsTest.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@SpringBootApplication
@RestController
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping("/hello")
	public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		return String.format("Hello %s!", name);
	}

	@GetMapping("/")
	public String greet(String greet) {
		return String.format("Welcome to demo app");
	}

	@GetMapping("/version")
	public Map<String, String> version() {
		UUID uuid = UUID.randomUUID();
		HashMap<String, String> map = new HashMap<>();
		map.put("description", "pre-interview technical test");
		map.put("version", "1.0.0");
		map.put("build_sha", String.valueOf(uuid).substring(0,12));
		return map;
	}
}
