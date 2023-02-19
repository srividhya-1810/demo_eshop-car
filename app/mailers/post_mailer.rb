class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.post_created.subject
  #
  def post_created
    @greeting = "Hi"
    @user=params[:user]
    @order=params[:order]
    @to=Car.find(@order.car_id)
    @send=User.find(@to.user_id)
    mail(
      from: "car_zone@example.org",
      to:@send.email,
      subject: "Car bought"
    ) 
  end
end
