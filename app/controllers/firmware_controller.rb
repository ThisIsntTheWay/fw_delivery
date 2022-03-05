class FirmwareController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @paramIngress = params[:project]
  end

  def create
    @paramPOST = params[:firmware]
    @errorMsg = "Invalid data: "
    
    # Validate
    @postContentIsValid = true
    if @paramPOST[:project] == ""
      @postContentIsValid = false
      @errorMsg += "param PROJECT invalid."
    end

    if @postContentIsValid && (@paramPOST[:version_number].is_a? Numeric)
      @postContentIsValid = false
      @errorMsg += "param VERSION_NUMBER invalid."
    end

    if @postContentIsValid && (@paramPOST[:release_type] == "")
      @postContentIsValid = false
      @errorMsg += "param RELEASE_TYPE invalid."
    end
  end
end
