require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    let(:valid_attributes) do
      { name: 'Cuenta de Ahorros', state: :active, balance: 10000, currency: 'USD' }
    end

    context 'with valid attributes' do
      it 'is valid' do
        account = Account.new(valid_attributes)
        expect(account).to be_valid
      end
    end
 
    context 'with invalid attributes' do
      it 'is invalid without a name' do
        account = Account.new(valid_attributes.except(:name))
        expect(account).to be_invalid
        expect(account.errors[:name]).to include("can't be blank")
      end

      it 'is invalid without a balance' do
        account = Account.new(valid_attributes.except(:balance))
        expect(account).to be_invalid
        expect(account.errors[:balance]).to include("can't be blank")
      end

      it 'is invalid without a currency' do
        account = Account.new(valid_attributes.except(:currency))
        expect(account).to be_invalid
        expect(account.errors[:currency]).to include("can't be blank")
      end
    end
  end
end

