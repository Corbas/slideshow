package uk.co.corbas.slides.db;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

/**
 * Class to store IoC wiring for Spring. Currently only handles the
 * database client.
 */
@Component
@ComponentScan
public class Wiring {

    @Autowired
    private Environment env;

    @Bean
    public Client client() {
        Client client = new Client(env);
        return client;
    }

}
