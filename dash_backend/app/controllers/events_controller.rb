class EventsController < ApplicationController

  def index
    @events = Event.all
    render json:@events
  end

  def show
    @event = Event.find_by(id: params[:id])
    render json:@event
  end

  def create
    @event = Event.new(title: params[:title], location: params[:location], description: params[:description], start_time: params[:start_time], end_time: params[:end_time])
    if @event.valid?
      @event.save
      Invite.create(user_id: params[:user_id], event_id: @event.id, admin: true, status: "confirmed", host: true )
      @user = User.find_by(id: params[:user_id])
      @friends = params[:friends]
      @friends.each do |friend|
        Invite.create(user_id: friend["id"], event_id: @event.id)
      end
      @friends.each do |friend|
        Emailer.sendEmail(@user.name).deliver!
      end
      render json:@event
    else
      render json:{message: "Invalid Information. Please try again"}, status: 401
    end
  end

  def update
    @event = Event.find_by(id: params[:id])
    @event.update(title: params[:title], location: params[:location], description: params[:description], start_time: params[:start_time], end_time: params[:end_time])
    if @event.valid?
      @friends = params[:friends]
      @user = User.find_by(id: params[:user_id])
      @friends.each do |friend|
        Invite.create(user_id: friend["id"], event_id: @event.id)
      end
      @friends.each do |friend|
        Emailer.sendEmail(@user.name).deliver!
      end
      render json:@event
    else
      render json:{message: "Invalid Information. Please try again"}, status: 401
    end
  end

  def destroy
    @event = Event.find_by(id: params[:id])
    @event.destroy
    render json:{message: "Event Destroyed"}, status: 200
  end

  private

  def event_params
    params.permit(:id, :title, :location, :description, :start_time, :end_time, :user_id, :friends)
  end

end
