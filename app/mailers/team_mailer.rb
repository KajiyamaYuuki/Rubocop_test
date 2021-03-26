class TeamMailer < ApplicationMailer
    def new_owner_notification_mail(new_owner)
      @new_owner = new_owner
      mail(to: @new_owner.email, subject: "新チームリーダー任命通知")
    end
end
