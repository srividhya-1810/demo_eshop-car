class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.post_created.subject
  #
  def post_created
    @greeting = "Hi"
    @user=params[:user]
    @car=params[:car]
    @send=User.find(@car.user_id)
    mail(
      from: "car_zone@example.org",
      to:@send.email,
      subject: "Car bought"
    ) 
  end
end
