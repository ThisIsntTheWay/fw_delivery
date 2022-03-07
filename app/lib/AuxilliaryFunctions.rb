module AuxilliaryFunctions
    def verify_bin(targetFile)
        f = File.binread targetFile
        byteArr = f.unpack 'C*'

        identifier = ""
        begin
            for i in 0..2 do
                hexNum = byteArr[i].to_s(16)
                hexNum = "0" + hexNum if (hexNum.length == 1)
                
                identifier += hexNum
            end
        rescue
            return {"isValid" => false}
        end

        # ESP32 bin file signature is 'E9 05 02'
        return {"fileSignature" => identifier, "isValid" => (identifier == "e90502")}
    end
end