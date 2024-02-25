require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should have_many(:transaction_users).dependent(:destroy) }
    it { should have_many(:users).through(:transaction_users) }
    it { should have_one_attached(:csv_file) }
  end

  describe 'constants' do
    it 'should have TYPE_OF_TRANSACTION constant' do
      expect(Transaction::TYPE_OF_TRANSACTION).to eq(['Sale', 'Lease', 'Referral'])
    end
  end

  describe 'methods' do
    describe '.filter_by_year_and_month' do
      it 'should return filtered transactions' do
        # Add your test logic here
      end
    end

    describe 'create transactions' do
      it 'should create a new transaction' do
      end

      it 'should create a new transaction with a csv file' do

      end

      it 'should not create a new transaction if users are not present' do
      end

      it 'should create and update scores' do

      end

      it 'should not create if type_of_transaction is Refered' do

      end
    end
  end

end
