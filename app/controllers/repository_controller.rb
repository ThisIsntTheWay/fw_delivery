class RepositoryController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def manage
    @repository = FirmwareRepository.find(params[:id])
    if !@repository
      p "Repository with ID #{params[:id].to_s} does not exist."
    end
  end

  def manage_objects
    @repository = FirmwareRepository.find(params[:id])
    if !@repository
      p "Repository with ID #{params[:id].to_s} does not exist."
    end
  end

  def delete
    @authCode = "123"

    @authCodeProvided = JSON.parse(request.body.read)["authentication"]
    puts @authCodeProvided

    if @authCodeProvided.nil?
      render :json => { :success => false, :message => "Auth code expected." }, status: 403
      return
    elsif @authCodeProvided != @authCode
      render :json => { :success => false, :message => "Auth code invalid" }, status: 403
      return
    end

    @repository = FirmwareRepository.find(params[:id])

    @verdict = true
    @verdictMsg = "OK"

    if @repository
      begin
        @id = @repository.id
        @result = @repository.destroy
        if @result
          @verdictMsg = "Repository of ID #{@id} destroyed."
        end
      rescue => exception
        @verdict = false
        @verdictMsg = "Deletion has failed: #{exception.to_s}"
      end
    else
      @verdict = false
      @verdictMsg = "Respository with ID #{params[:id].to_s} not found."
    end

    begin
      render :json => { :success => @verdict, :message => @verdictMsg }, status: if @verdict then 200 else 400 end
    rescue => exception
      render :json => { :success => false, :message => "Exception encountered: ", :exception => exception.to_s }, status: 500    
    end
  end

  def create
    @paramPOST = params[:repository]
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
    if @paramPOST[:project_name] == ""
      @postContentIsValid = false
      @errorMsg += "param PROJECT_NAME is empty. "
    end

    if @paramPOST[:description] == ""
      @postContentIsValid = false
      @errorMsg += "param DESCRIPTION is empty. "
    end
  
    # Save to database
    if @postContentIsValid
      begin
        puts "Writing to DB: PROJECT: #{@paramPOST[:project_name]}, DESC: #{@paramPOST[:description]}"
        FirmwareRepository.create(project: @paramPOST[:project_name], description: @paramPOST[:description])
      rescue => exception
        render :json => { :success => false, :message => "Eexception encountered: ", :exception => exception.to_s }, status: 500
        return
      end
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
