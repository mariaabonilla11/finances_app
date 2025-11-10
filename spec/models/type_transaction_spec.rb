require 'rails_helper'

RSpec.describe TypeTransaction, type: :model do
  describe 'validations' do
    let(:valid_attributes) do
      { name: 'Ingreso', state: :active }
    end

    context 'with valid attributes' do
      it 'is valid' do
        type_transaction = TypeTransaction.new(valid_attributes)
        expect(type_transaction).to be_valid
      end
    end
 
    context 'with invalid attributes' do
      it 'is invalid without a name' do
        type_transaction = TypeTransaction.new(valid_attributes.except(:name))
        expect(type_transaction).to be_invalid
        expect(type_transaction.errors[:name]).to include("can't be blank")
      end
    end
  end
end
