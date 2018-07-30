require 'rails_helper'

describe MoneyTransaction do
  context 'relationship' do
    subject(:money_transaction) { MoneyTransaction.new }
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
end