package klopfen.rocks.fwdelivery.configurator;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

public class FwDeliveryConfigurator {
    ObjectMapper objectMapper = new ObjectMapper();

    String dbServerIP;
    String dbServerPort;
    String dbServerUser;
    String dbServerPass;
    String dbDatabaseName;

    public FwDeliveryConfigurator() {
        // Check for JSON
    }
}
