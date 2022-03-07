class Firmware < ApplicationRecord
    extend AuxilliaryFunctions

    belongs_to :firmware_repository
end
