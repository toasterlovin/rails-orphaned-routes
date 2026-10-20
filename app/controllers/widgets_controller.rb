class WidgetsController < ApplicationController
  before_action :set_widget, only: %i[ show edit update destroy ]

  def index
    @widgets = Widget.all
  end

  def show
  end

  def new
    @widget = Widget.new
  end

  def edit
  end

  def create
    @widget = Widget.new(widget_params)

    if @widget.save
      redirect_to @widget, notice: "Widget was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @widget.update(widget_params)
      redirect_to @widget, notice: "Widget was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @widget.destroy!
    redirect_to widgets_path, notice: "Widget was successfully destroyed.", status: :see_other
  end

  private
    def set_widget
      @widget = Widget.find(params.expect(:id))
    end

    def widget_params
      params.expect(widget: [ :name ])
    end
end
