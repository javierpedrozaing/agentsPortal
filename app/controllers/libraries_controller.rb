class LibrariesController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_file_item, only: [:show, :edit, :update, :destroy]

  def index
    @file_items = Library.all
  end

  def new
    @file_item = Library.new
  end

  def edit
  end

  def create
    @file_item = current_user.libraries.build(file_item_params)

    respond_to do |format|
      if @file_item.save
        format.html { redirect_to libraries_path, notice: 'File uploaded successfully.' }
        format.json { render :index, status: :created, location: @file_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @file_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def update
    if @file_item.update(file_item_params)
      redirect_to @file_item, notice: 'File item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @file_item.destroy
    redirect_to libraries_path, notice: 'File item was successfully destroyed.'
  end

  private

  def set_file_item
    @file_item = Library.find(params[:id])
  end

  def file_item_params
    params.require(:library).permit(:file_name, :file_description, :file_type, :user_id, :file, :category_id)
  end
end
