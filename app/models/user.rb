class User < ApplicationRecord
  has_many :shop_bookmarks, dependent: :destroy
  has_many :shops, through: :shop_bookmarks, source: :shop
  has_many :reviews, dependent: :destroy

  # 診断
  has_many :user_answers
  has_many :diagnoses
  has_many :user_fragrance_scores


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { provider == "google_oauth2" }

  # 外部の認証サービスから情報を取得し、ユーザーをデータベースに登録
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def bookmark(shop)
    shop_bookmarks.create(shop: shop)
  end

  def unbookmark(shop)
    shop_bookmarks.find_by(shop: shop)&.destroy
  end

  def bookmark?(shop)
    shop_bookmarks.exists?(shop_id: shop.id)
  end

  def own?(object)
    id == object&.user_id
  end

  def fragrance_diagnoses
    diagnoses.includes(:user_fragrance_score)
  end
end
