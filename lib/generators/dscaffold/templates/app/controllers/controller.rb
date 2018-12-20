class <%= plural_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_name %>, only: [:show, :edit, :update, :destroy]

  # GET /<%= plural_name %>
  # GET /<%= plural_name %>.json
  def index
    @<%= plural_name %> = <%= class_name %>.all
  end

  # GET /<%= plural_name %>/1
  # GET /<%= plural_name %>/1.json
  def show
  end

  # GET /<%= plural_name %>/new
  def new
    @<%= singular_name %> = <%= class_name %>.new
  end

  # GET /<%= plural_name %>/1/edit
  def edit
  end

  # POST /<%= plural_name %>
  # POST /<%= plural_name %>.json
  def create
    @<%= singular_name %> = <%= class_name %>.new(<%= singular_name %>_params)

    respond_to do |format|
      if @<%= singular_name %>.save
        format.html { redirect_to <%= plural_name %>_path, notice: '<%= human_title %> was successfully created.' }
        format.json { render :show, status: :created, location: @<%= singular_name %> }
      else
        format.html { render :new }
        format.json { render json: @<%= singular_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /<%= plural_name %>/1
  # PATCH/PUT /<%= plural_name %>/1.json
  def update
    respond_to do |format|
      if @<%= singular_name %>.update(<%= singular_name %>_params)
        format.html { redirect_to <%= plural_name %>_path, notice: '<%= class_name %> was successfully updated.' }
        format.json { render :show, status: :ok, location: @<%= singular_name %> }
      else
        format.html { render :edit }
        format.json { render json: @<%= singular_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= plural_name %>/1
  # DELETE /<%= plural_name %>/1.json
  def destroy
    @<%= singular_name %>.destroy
    respond_to do |format|
      format.html { redirect_to <%= plural_name %>_url, notice: '<%= class_name %> was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_<%= singular_name %>
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def <%= singular_name %>_params
    params.require(:<%= singular_name %>).permit(:name)
  end
end
