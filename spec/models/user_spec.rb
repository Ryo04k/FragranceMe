require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    it 'ユーザーネーム、メールアドレス、パスワードがあれば有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'メールアドレスが一意であること' do
      user1 = create(:user)
      user2 = build(:user)
      user2.email = user1.email
      user2.valid?
      expect(user2.errors[:email]).to include('はすでに存在します')
    end

    it 'ユーザーネーム、メールアドレス、パスワードは必須項目であること' do
      user = build(:user, name: nil, email: nil, password: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
      expect(user.errors[:email]).to include('を入力してください')
      expect(user.errors[:password]).to include('を入力してください')
    end

    it 'ユーザーネームは50文字以下であること' do
      user = build(:user, name: 'a' * 100)
      user.valid?
      expect(user.errors[:name]).to include('は50文字以内で入力してください')
    end

    it 'パスワードの長さが6文字以上であること' do
      user = build(:user, password: 123)
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
  end
end
