class Firmware < ApplicationRecord
    mount_uploader :path_to_bin, FirmwareUploader
    belongs_to :firmware_repository

    extend AuxilliaryFunctions
end
