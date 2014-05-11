class Admin::VideosController < AdminController

  def new
    @video = Video.new
  end

  def create 
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Succesfully saved video '#{@video.title}'"
      redirect_to new_admin_video_path
    else
      flash[:error] = 'Video cannot be saved. Check errors for details.'
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit!
  end

end