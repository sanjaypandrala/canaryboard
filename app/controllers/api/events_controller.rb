class Api::EventsController < ApiController
  before_filter :get_events
  before_filter :get_event, only: [ :show, :update, :destroy ]

  # GET /api/indicators/:indicator_id/events
  def index
    render json: @events.map(&:api_return_format)
  end

  # POST /api/indicators/:indicator_id/events
  def create
    @event = @events.new(params[:event])
    if @event.save
      render json: @event.api_return_format
    else
      render json: @event.errors
    end
  end

  # GET /api/indicators/:indicator_id/events/:id
  def show
    render json: @event.api_return_format
  end

  # PUT /api/indicators/:indicator_id/events/:id
  def update
    if @event.update_attributes(params[:event])
      render json: @event.api_return_format
    else
      render json: @event.errors
    end
  end

  # DELETE /api/indicators/:indicator_id/events/:id
  def destroy
    if @event.destroy
      render json: @event.api_return_format
    else
      render json: @event.errors
    end
  end

  private

  def get_events
    @events ||= Indicator.find(params[:indicator_id]).events rescue render(json: {error: "No such indicator"}) and return
  end

  def get_event
    @event ||= @events.find(params[:id]) rescue render(json: {error: "No such event"}) and return
  end
end
