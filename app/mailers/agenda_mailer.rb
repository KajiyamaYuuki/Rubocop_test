class AgendaMailer < ApplicationMailer
  def send_mail(user)
    @user = user
    mail(to: @user.email, subject: "Agenda削除通知")
  end

  def self.send_mail_users(users)
    users.each do |user|
      AgendaMailer.send_mail(user).deliver_now
    end
  end
end
