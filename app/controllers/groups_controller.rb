class GroupsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    
    #layout "video_layout"
    config_opentok
    @group = Group.find(params[:id])
    data_hash = { :user_id => "#{current_user.id}", :user_name => "#{current_user.name}" } 
    @tok_token = @apiObj.generate_token session_id: @group.session_id, 
       connection_data: data_hash.to_json

    render :layout => 'video_layout'
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    config_opentok
    session = @apiObj.create_session(request.remote_addr )    
    @group = Group.new(params[:group])
    @group.session_id = session.session_id        

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_url, notice: 'Group was successfully created.' }
        format.json { render json: group_url, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to groups_url, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  private
    def config_opentok
      if @opentok.nil?
        @api_key = 11796762                # should be a number
        @api_secret = 'f6989f3520873c70f414edfd3f5d02e88ab4a97b'            # should be a string
        @apiObj = OpenTok::OpenTokSDK.new @api_key, @api_secret
      end
    end
end
