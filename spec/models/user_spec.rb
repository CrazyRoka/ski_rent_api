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

  context 'transactions' do
    let(:payer) { create(:user, email: 'payer@gmail.com', balance: 1000) }
    let(:payee) { create(:user, email: 'payee@gmail.com', balance: 100) }

    context 'valid money transaction' do

      it 'should translate money from payer to payee' do
        payer.pay_to(payee, 200)
        expect(payer.balance).to eq(800)
        expect(payee.balance).to eq(300)
      end

      it 'should translate money from payee to payer' do
        payee.pay_to(payer, 100)
        expect(payer.balance).to eq(1100)
        expect(payee.balance).to eq(0)
      end
    end

    context 'invalid money transaction' do

      it 'should not translate money' do
        expect { payer.pay_to(payee, 1001) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { payee.pay_to(payer, 101) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(payer.reload.balance).to eq(1000)
        expect(payee.reload.balance).to eq(100)
      end
    end
  end
end