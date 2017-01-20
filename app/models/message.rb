class Message 
  include ActiveModel::Model
  attr_accessor :name, :tel, :email, :subject, :content, :enterprise
  validates :name, :tel, :email, :subject, :content, presence: true

end
