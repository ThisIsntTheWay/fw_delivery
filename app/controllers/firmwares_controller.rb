class FirmwaresController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @paramIngress = params[:project]
  end

  def new
    @firmware = Firmware.new
  end

  def create
    @paramPOST = params[:firmware]
    @postContentIsValid = true
    @errorMsg = "Error: "
    
    # Authenticate
    @authCode = "123"
    if @paramPOST.nil? || (@paramPOST[:authentication] == "")
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
      @projectID = @paramPOST[:project].to_i
      if !@projectID
        @postContentIsValid = false
        @errorMsg += "param PROJECT must be a number. "
      elsif !(FirmwareRepository.find(@projectID))
        @postContentIsValid = false
        @errorMsg += "param PROJECT references an invalid project. "
      end
    end

    if @paramPOST[:version_number].nil?
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
    @verdict = false
    if @postContentIsValid
      @forRelease = if @paramPOST[:for_release] == "on" then true else false end

      @targetRepository = FirmwareRepository.find(@projectID)
      puts @targetRepository.id
      puts "Found repo: #{@projectID.to_s}"

      @result = @targetRepository.firmwares.create(
        version_number: @paramPOST[:version_number],
        release_type: @paramPOST[:release_type],
        for_release: @forRelease,
        is_hidden: false
      )

      if @result
        @verdict = true
        @verdictMsg = "Firmware registered. ID: #{@result.id}"
      else
        @verdictMsg = "Failure during firmware registration."
      end
    end

    # Create response
    begin
      render :json => { :success => @verdict, :message => @verdictMsg }, status: if @verdict then 200 else 400 end
    rescue => exception
      render :json => { :success => false, :message => "Unhandled exception encountered.", :exception => exception.to_s }, status: 500
    end
  end
end
