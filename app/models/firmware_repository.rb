class FirmwareRepository < ApplicationRecord
    has_many :firmwares, dependent: :destroy
end
