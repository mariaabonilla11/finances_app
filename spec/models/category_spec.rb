require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    let(:valid_attributes) do
      { name: 'Transporte', state: :active }
    end

    context 'with valid attributes' do
      it 'is valid' do
        category = Category.new(valid_attributes)
        expect(category).to be_valid
      end
    end
 
    context 'with invalid attributes' do
      it 'is invalid without a name' do
        category = Category.new(valid_attributes.except(:name))
        expect(category).to be_invalid
        expect(category.errors[:name]).to include("can't be blank")
      end
    end
  end
end

