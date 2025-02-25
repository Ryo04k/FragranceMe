require "rails_helper"

RSpec.describe Diagnosis, type: :model do
  let(:user) { create(:user) }
  let(:fragrance) { create(:fragrance) }
  let(:scores) { { floral: 2, citrus: 3, oriental: 1, spicy: 4, herbal: 5, woody: 6 } }

  describe '#create_with_scores' do
    context '有効な診断データが渡された場合' do
      it '診断データと関連するユーザーフレグランススコアが保存されること' do
        diagnosis = Diagnosis.create_with_scores(user, fragrance.id, scores)

        expect(diagnosis).to be_persisted
        expect(diagnosis.user).to eq(user)
        expect(diagnosis.fragrance).to eq(fragrance)
        expect(diagnosis.user_fragrance_score.floral_score).to eq(2)
        expect(diagnosis.user_fragrance_score.citrus_score).to eq(3)
        expect(diagnosis.user_fragrance_score.oriental_score).to eq(1)
        expect(diagnosis.user_fragrance_score.spicy_score).to eq(4)
        expect(diagnosis.user_fragrance_score.herbal_score).to eq(5)
        expect(diagnosis.user_fragrance_score.woody_score).to eq(6)
      end
    end

    context "診断の作成に失敗した場合" do
      it 'ActiveRecord::RecordInvalidエラーを発生させる' do
        allow(Diagnosis).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Diagnosis.new))

        expect {
          Diagnosis.create_with_scores(user, fragrance.id, scores)
        }.to raise_error(RuntimeError, /診断結果の保存に失敗しました/)
      end
    end
  end
end
