package klopfen.rocks.fwdelivery.configurator;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.nio.file.*;

public class FwDeliveryConfigurator {
    String dbServerIP;
    String dbServerPort;
    String dbServerUser;
    String dbServerPass;
    String dbDatabaseName;

    String cfgPath = ".\\config_application.json";

    public FwDeliveryConfigurator() {
        Path path = Paths.get(this.cfgPath);

        if (Files.notExists(path)) {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(new File(this.cfgPath), this);
        }
    }
}