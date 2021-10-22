package klopfen.rocks.fwdelivery.configurator;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.File;
import java.nio.file.*;

public class FwDeliveryConfigurator {
    ObjectMapper objectMapper = new ObjectMapper();

    public static String dbServerIP;
    public static String dbServerPort;
    public static String dbServerUser;
    public static String dbServerPass;
    public static String dbDatabaseName;

    String cfgPath = ".\\config_application.json";

    public void createConfiguration() {
        Path path = Paths.get(this.cfgPath);

        if (Files.notExists(path)) {
            this.objectMapper.writeValue(new File(this.cfgPath), this);
        }
    }

    public boolean readConfiguration() {
        Path path = Paths.get(this.cfgPath);

        if (Files.notExists(path)) {
            return false;
        } else {

            return true;
        }
    }
}