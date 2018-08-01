require 'rails_helper'

describe MoneyTransaction do
  context 'relationship' do
    subject(:money_transaction) { described_class.new }
    it 'should belongs to  payer' do
      expect { money_transaction.payer = User.new }.not_to raise_error
    end

    it 'should belongs to  payee' do
      expect { money_transaction.payee = User.new }.not_to raise_error
    end

    it 'should have one polymorphic target' do
      expect { money_transaction.target = Booking.new }.not_to raise_error
      expect { money_transaction.target = Item.new }.not_to raise_error
    end
  end

  context 'transaction' do
    let(:create_transaction) do
      CreateMoneyTransaction.new.call(payer: payer, payee: payee,
                                      payment_cents: 150, target: item)
    end
    let(:payee) { create(:user, email: 'test@email.com', balance: 0) }
    let(:payer) { create(:user, email: 'something@email.com', balance: 200) }
    let(:item) { create(:item, owner: payee) }

    context 'user have enough money' do
      it 'should perform transaction' do
        expect { create_transaction }.to change { described_class.count }.by(1)
        expect(payer.reload.balance).to eq(50)
        expect(payee.reload.balance).to eq(150)
      end
    end

    context 'user have not enough money' do
      before { payer.balance = 100; payer.save }

      it 'should not perform transaction' do
        expect { create_transaction }.to change { described_class.count }.by(0)
        expect(payer.reload.balance).to eq(100)
        expect(payee.reload.balance).to eq(0)
      end
    end
  end
end
