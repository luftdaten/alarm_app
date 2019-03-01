class User < Patron
  devise :invitable, :registerable, :confirmable
  has_many :notifications, dependent: :destroy
  validates :name, length: { minimum: 2 }, allow_blank: true
end
