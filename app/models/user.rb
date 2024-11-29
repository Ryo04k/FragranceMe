class User < ApplicationRecord
  has_many :shop_bookmarks, dependent: :destroy
  has_many :shops, through: :shop_bookmarks, source: :shop

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def bookmark(shop)
    shop_bookmarks << shop
  end

  def unbookmarks(shop)
    shop_bookmarks.destroy(shop)
  end

  def bookmark?(shop)
    shop_bookmarks.include?(shop)
  end
end
