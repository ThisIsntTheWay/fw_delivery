class FirmwaresController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @repositories = FirmwareRepository.all
    @firmware = Firmware.count
  end

  def new
    @firmware = Firmware.new
  end

  def create
    puts "CALLED CREATE"
    @paramPOST = params[:firmware]
    @postContentIsValid = true
    @responseMsg = "Error: "
    
    # Authenticate
    @authCode = "123"
    if @paramPOST.nil? || (@paramPOST[:authentication] == "")
      @postContentIsValid = false
      @responseMsg += "Authentication not provided. "
    elsif @paramPOST[:authentication] != @authCode
      @postContentIsValid = false
      render :json => { :success => false, :message => "Unauthorized" }, status: 403
      return
    end

    # Validate
    if @paramPOST[:firmware_repository_id] == ""
      @postContentIsValid = false
      @responseMsg += "param PROJECT is empty. "
    else
      @projectID = @paramPOST[:firmware_repository_id].to_i
      if !@projectID
        @postContentIsValid = false
        @responseMsg += "param PROJECT must be a number. "
      elsif !(FirmwareRepository.find(@projectID))
        @postContentIsValid = false
        @responseMsg += "param PROJECT references an invalid project. "
      end
    end

    if @paramPOST[:version_number].nil? || (@paramPOST[:version_number] == "")
      @postContentIsValid = false
      @responseMsg += "param VERSION_NUMBER is invalid. "
    end

    @releaseTypeValidationSet = ['alpha', 'beta', 'release']
    if @paramPOST[:release_type] == ""
      @postContentIsValid = false
      @responseMsg += "param RELEASE_TYPE is empty."
    elsif !@releaseTypeValidationSet.include? @paramPOST[:release_type]
      @postContentIsValid = false
      @responseMsg += "param RELEASE_TYPE is invalid. Valid values: '" + @releaseTypeValidationSet.join(', ') + "'"
    end
  
    # Save to database
    @verdict = false
    if @postContentIsValid
      #@forRelease = if @paramPOST[:for_release] == "on" then true else false end

      @targetRepository = FirmwareRepository.find(@projectID)
      puts @targetRepository.id
      puts "Found repo: #{@projectID.to_s}"

      @firmwareCreation = @targetRepository.firmwares.new(post_params)
      if @firmwareCreation.save
        @verdict = true
        @responseMsg = "Firmware registered."
      else
        @responseMsg = "Failure during firmware registration."
      end
    end

    # Create response
    begin
      render :json => { :success => @verdict, :message => @responseMsg }, status: if @verdict then 200 else 400 end
    rescue => exception
      render :json => { :success => false, :message => "Unhandled exception encountered.", :exception => exception.to_s }, status: 500
    end
  end

  def destroy
    @authCode = "123"

    @authCodeProvided = JSON.parse(request.body.read)["authentication"]
    puts @authCodeProvided

    if @authCodeProvided.nil? || (@authCodeProvided == "")
      render :json => { :success => false, :message => "Auth code expected." }, status: 403
      return
    elsif @authCodeProvided != @authCode
      render :json => { :success => false, :message => "Auth code invalid" }, status: 403
      return
    end

    @firmware = Firmware.find(params[:id])

    @verdict = true
    @verdictMsg = "OK"

    if @firmware
      begin
        @id = @firmware.id
        @result = @firmware.destroy
        if @result
          @verdictMsg = "Firmware of ID #{@id} destroyed."
        end
      rescue => exception
        @verdict = false
        @verdictMsg = "Deletion has failed: #{exception.to_s}"
      end
    else
      @verdict = false
      @verdictMsg = "Firmware with ID #{params[:id].to_s} not found."
    end

    begin
      render :json => { :success => @verdict, :message => @verdictMsg }, status: if @verdict then 200 else 400 end
    rescue => exception
      render :json => { :success => false, :message => "Exception encountered: ", :exception => exception.to_s }, status: 500    
    end
  end

  private

  def post_params
    params.require(:firmware).permit(:name, :version_number, :release_type, :firmware_repository_id, :path_to_bin, :for_release)
  end
end
