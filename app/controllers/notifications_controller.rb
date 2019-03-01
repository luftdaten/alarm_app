class NotificationsController < ApplicationController
  def index
    @notifications = current_user.try(:notifications)
    if @notifications.blank?
      redirect_to new_user_session_path, notice: "Erst bitte erst einloggen..."
    end
  end

  def create
    #current_user = AuthorizeApiRequest.call(request.headers).result
    sensors = OwnSensor.where(extern_db_id: params[:notification][:sensor_ids]).map { |s| s.sensor_relations.new() }
    @notification = current_user.notifications.create(
      name: params[:notification][:name], enabled: true, sensor_relations: sensors)
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.json { render json: { sensors: @notification } }
    end
  end

  def update
    @notification = current_user.notifications.where(id: params[:id]).first
    @notification.update_attributes(notification_params)
    respond_to do |format|
      format.json { respond_with_bip(@notification) }
    end
  end

  def add_sensor
    #current_user = AuthorizeApiRequest.call(request.headers).result
    sensors = OwnSensor.where(extern_db_id: params[:sensor_ids]).map { |s| s.sensor_relations.new() }
    @notification = current_user.notifications.find_or_create_by(
      sensor_relations: sensors
    )
  end

  def destroy
    puts params[:id]
    #current_user = AuthorizeApiRequest.call(request.headers).result
    current_user.notifications.where(id: params[:id]).first.destroy
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.json { }
    end
    #todo: test it
  end

  private
  def notification_params
    params.require(:notification).permit(:enabled,:name,:aggregation_time,:limit_value,:interval_to_send)
  end

end
