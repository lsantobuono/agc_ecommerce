class Message 
  include ActiveModel::Model
  attr_accessor :name, :tel, :email, :subject, :content, :subject, :enterprise
  validates :name, :tel, :email, :subject, :content, :subject, presence: true

end
