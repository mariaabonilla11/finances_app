require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:valid_attributes) do
      { first_name: 'Test', last_name: 'User', email: 'test@example.com', password: 'password' }
    end

    context 'with valid attributes' do
      it 'is valid' do
        user = User.new(valid_attributes)
        expect(user).to be_valid
      end
    end
 
    context 'with invalid attributes' do
      it 'is invalid without a first_name' do
        user = User.new(valid_attributes.except(:first_name))
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include("can't be blank")
      end

      it 'is invalid without a last_name' do
        user = User.new(valid_attributes.except(:last_name))
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include("can't be blank")
      end

      it 'is invalid without an email' do
        user = User.new(valid_attributes.except(:email))
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid when email is already taken' do
        User.create!(valid_attributes)
        user = User.new(valid_attributes)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end
end
