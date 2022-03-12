class FirmwareUploader < CarrierWave::Uploader::Base
  storage :file

  def extension_white_list
    %w(bin)
 end
end
