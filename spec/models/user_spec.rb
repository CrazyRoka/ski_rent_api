require 'rails_helper'

describe User do
  context 'relationship' do
    subject(:user) { User.new }
    it 'should have many items' do
      expect { user.items.build }.not_to raise_error
    end

    it 'should have many reviews' do
      expect { user.reviews.build }.not_to raise_error
    end

    it 'should have many received_reviews' do
      expect { user.received_reviews.build }.not_to raise_error
    end

    it 'should belongs to city' do
      expect { user.city = City.new }.not_to raise_error
    end

    it 'should have item reviews' do
      expect { user.received_item_reviews.build }.not_to raise_error
    end

    it 'should have many bookings' do
      expect { user.bookings.build }.not_to raise_error
    end

    it 'should have many received transactions' do
      expect { user.received_transactions.build }.not_to raise_error
    end

    it 'should have many payed transactions' do
      expect { user.payed_transactions.build }.not_to raise_error
    end
  end

  context 'authentication' do
    let(:city) { City.new(name: 'example') }
    subject(:user) { User.new(name: 'John', password: '', email: 'john@example.com', city: city) }
    it 'should have correct password' do
      expect(user.valid?).to eq(false)

      user.password = 'my_name_is_john'
      expect(user.valid?).to eq(true)
    end
  end

  context 'transaction' do
    let(:create_transaction) do
      CreateMoneyTransaction.new.call(payer: payer, payee: payee,
                                      payment_cents: 150, target: item)
    end
    let(:payee) { create(:user, email: 'test@email.com', balance: 0) }
    let(:payer) { create(:user, email: 'something_else@email.com', balance: 200) }
    let(:item) { create(:item, owner: payee) }

    context 'user have enough money' do
      it 'should perform transaction' do
        expect { create_transaction }.to change { MoneyTransaction.count }.by(1)
        expect(payer.reload.balance).to eq(50)
        expect(payee.reload.balance).to eq(150)
      end
    end

    context 'user have not enough money' do
      before { payer.balance = 100; payer.save }

      it 'should not perform transaction' do
        expect { create_transaction }.to change { MoneyTransaction.count }.by(0)
        expect(payer.reload.balance).to eq(100)
        expect(payee.reload.balance).to eq(0)
      end
    end
  end
end