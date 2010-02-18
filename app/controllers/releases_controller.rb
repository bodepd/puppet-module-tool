class ReleasesController < ApplicationController

  before_filter :find_mod
  before_filter :find_release, :only => [:show]
  
  def new
    @release = @mod.releases.new
  end

  def create
    @release = @mod.releases.new(params[:release])
    if @release.save
      notify_of "Released #{@release.version}"
      redirect_to module_path(@user, @mod)
    else
      notify_of :error, "Could not save release"
      render :action => 'new'
    end
  end

  def show
  end

  private

  def find_mod
    @user = User.find_by_username(params[:user_id])
    @mod = @user.mods.find_by_name(params[:mod_id])
  end

  def find_release
    @release = @mod.releases.find_by_version(params[:id])
  end
  
end
