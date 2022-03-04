# Configurator class
# Parses a JSON file and handles empty keys

require 'json'

class Configurator
    def initialize(targetFile)
        @@jsonFileName = targetFile
        raise "Config file '#{targetFile}' not found." if !File.file?(@@jsonFileName)
    end

    def parse
        @jsonFile = File.read(@@jsonFileName)
        @@jsonData = JSON.parse(@jsonFile)

        @@listenPort = @@jsonData[:ListenPort] ? @@jsonData[:ListenPort] : 80
    end

    def JsonData
        @@jsonData
    end

    def ListenPort
        @@listenPort
    end
end