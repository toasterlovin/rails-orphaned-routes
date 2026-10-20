class ThingsController < ApplicationController
  before_action :set_thing, only: %i[ show edit update destroy ]

  def index
    @things = Thing.all
  end

  def show
  end

  def new
    @thing = Thing.new
  end

  def edit
  end

  def create
    @thing = Thing.new(thing_params)

    if @thing.save
      redirect_to @thing, notice: "Thing was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @thing.update(thing_params)
      redirect_to @thing, notice: "Thing was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @thing.destroy!
    redirect_to things_path, notice: "Thing was successfully destroyed.", status: :see_other
  end

  private
    def set_thing
      @thing = Thing.find(params.expect(:id))
    end

    def thing_params
      params.expect(thing: [ :name ])
    end
end
