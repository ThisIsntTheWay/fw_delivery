class FirmwareController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @paramIngress = params[:project]
  end

  def create
    @paramPOST = params[:firmware]
    @postContentIsValid = true
    @errorMsg = "Error: "
    
    # Authenticate
    @authCode = "123"
    if @paramPOST[:authentication] == ""
      @postContentIsValid = false
      @errorMsg += "Authentication not provided. "
    elsif @paramPOST[:authentication] != @authCode
      @postContentIsValid = false
      render :json => { :success => false, :message => "Unauthorized" }, status: 403
      return
    end

    # Validate
    if @paramPOST[:project] == ""
      @postContentIsValid = false
      @errorMsg += "param PROJECT is empty. "
    else
      @forRelease = if @paramPOST[:for_release] == "on" then true else false end
    end

    if !@paramPOST[:version_number].is_a? Numeric
      @postContentIsValid = false
      @errorMsg += "param VERSION_NUMBER is invalid. "
    end

    @releaseTypeValidationSet = ['alpha', 'beta', 'release']
    if @paramPOST[:release_type] == ""
      @postContentIsValid = false
      @errorMsg += "param RELEASE_TYPE is empty."
    elsif !@releaseTypeValidationSet.include? @paramPOST[:release_type]
      @postContentIsValid = false
      @errorMsg += "param RELEASE_TYPE is invalid. Valid values: '" + @releaseTypeValidationSet.join(', ') + "'"
    end
  
    # Save to database
    if @postContentIsValid
      
    end

    # Create response
    begin
      @verdictMsg = if @postContentIsValid then "Success" else @errorMsg end
      render :json => { :success => @postContentIsValid, :message => @verdictMsg }, status: if @postContentIsValid then 200 else 400 end
    rescue => exception
      render :json => { :success => false, :message => "Unhandled exception encountered.", :exception => exception.to_s }, status: 500
    end
  end
end
