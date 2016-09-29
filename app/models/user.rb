class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_many :attentions
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.image = auth.info.image
      user.password = Devise.friendly_token[0,20]
    end
  end
  def self.new_with_session(params, session)
    super.tap do |user|
      if omniauth = session["devise.facebook_data"].except('extra')
        user.email = omniauth.info.email
        user.name = omniauth.info.name
        user.image = omniauth.info.image
      end
    end
  end
end
