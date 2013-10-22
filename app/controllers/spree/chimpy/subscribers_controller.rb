class Spree::Chimpy::SubscribersController < ApplicationController
  respond_to :html

  def create
    @subscriber = Spree::Chimpy::Subscriber.where(email: params[:chimpy_subscriber][:email]).first
    @subscriber = Spree::Chimpy::Subscriber.new(subscriber_params) unless @subscriber
    @subscriber.update_attributes(subscriber_params)
    if @subscriber.save
      Spree::Chimpy::Subscription.new(@subscriber).subscribe
      flash[:notice] = Spree.t(:success, scope: [:chimpy, :subscriber])
    else
      flash[:error] = Spree.t(:failure, scope: [:chimpy, :subscriber])
    end

    respond_with @subscriber, location: request.referer
  end
end

  def permitted_subscriber_attributes
    [:email]
  end
private
  def subscriber_params
    params.require(:chimpy_subscriber).permit(permitted_subscriber_attributes)
  end