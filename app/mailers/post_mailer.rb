class PostMailer < ApplicationMailer
  default from: 'tousifh111@gmail.com'


  def post_notification(post, user, subject)
    @post = post
    @user = user
    mail(to: @user.email, subject: subject)
  end

  
  def post_approved(post, user)
    post_notification(post, user, 'Your Post Has Been Approved')
  end

  def post_rejected(post, user)
    post_notification(post, user, 'Your Post Has Been Rejected')
  end

  def post_published(post, user)
    post_notification(post, user, 'Your Post Has Been Published')
  end

  def post_request_revision(post, user)
    post_notification(post, user, 'Your Post Has Been Sent for Revision')
  end
end
