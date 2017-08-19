package uk.co.corbas.slides;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@EnableAutoConfiguration
/* @ComponentScan(basePackages = { "co.uk.corbas.slides.db", "co.uk.corbas.slides.controller"}) */
public class SlidesApplication {

	public static void main(String[] args) {
		SpringApplication.run(SlidesApplication.class, args);
	}
}
