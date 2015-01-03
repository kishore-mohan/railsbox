class BoxesController < ApplicationController
  layout 'box', except: %w(edit)
  before_filter :find_box, only: %w(show edit download update)

  def create
    box = Box.create params: params
    redirect_to box_url(box)
  end

  def default
    render json: Box.default_configuration
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @box }
    end
  end

  def edit
  end

  def update
    @box.update_attributes params: params
    redirect_to box_url(@box), notice: t('updated')
  end

  def download
    configurator = Configurator.from_params(@box.params)
    builder = ConfigurationBuilder.new(configurator)
    zip_path = builder.build
    send_file zip_path, filename: configurator.file_name
  end

  private

  def find_box
    @box = Box.where(secure_id: params[:id]).first!
  end
end