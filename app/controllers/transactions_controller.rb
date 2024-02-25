require 'csv'

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :get_type_of_transactions, only: %i[ new edit ]
  before_action :get_agents_list, only: %i[ new edit ]
  before_action :new_transaction_instance, only: %i[ index new filter ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
  end

  # GET /transactions/1/edit
  def edit
  end

  def import
    file = params[:transaction][:csv_file]

    if file.present?
      data = file.read
      csv = CSV.parse(data, headers: true)

      csv.each do |row|
        ActiveRecord::Base.transaction do
          @transaction = Transaction.new
          transaction_attributes = [
            'current_date', 'agent1_name', 'agent2_name', 'agent3_name', 'agent1_licence',
            'agent2_licence', 'agent3_licence', 'type_of_transaction', 'property_address',
            'seller_lessor', 'buyer_lessee', 'agent_client', 'closing_date',
            'title_escrow_company', 'sale_purchase', 'bank_deposit',
            'transaction_fee_amount', 'commission_percentage', 'agent1_commission_percentage',
            'agent1_commission_amount', 'agent2_commission_percentage', 'agent2_commission_amount',
            'referral_to', 'referral_amount', 'office_commission_percentage', 'office_commission_amount'
          ]
          transaction_attributes.each do |attribute|
            @transaction.send("#{attribute}=", row[attribute])
          end

          user1 = Agent.find_by(licence: row['agent1_licence'])&.user
          user2 = Agent.find_by(licence: row['agent2_licence'])&.user
          user3 = Agent.find_by(licence: row['agent3_licence'])&.user

          if @transaction.save!
            users = []

            if user1.nil? && user2.nil? && user3.nil?
              raise ActiveRecord::Rollback, 'some agents are not found'
            else
              users << user1 << user2 << user3
              users.compact!

              @transaction.users << users
              update_scores(@transaction, users)
            end
          end
        end
      end
      @transactions = Transaction.all
      render :index, notice: 'CSV file was successfully imported.'
    else
      redirect_to new_transaction_path, alert: 'Please select a CSV file.'
    end
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    users = User.where(id: [@transaction.agent1_name, @transaction.agent2_name, @transaction.agent3_name].compact)
    @transaction.users << users

    update_scores(@transaction, users)
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, notice: "Transaction was successfully created." }
        format.json { render :index, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_path, notice: "Transaction was successfully updated." }
        format.json { render :index, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_scores(transaction, users)
    users.reject!(&:nil?) if users.is_a?(Array)
    return unless transaction.present? && users.present?

    users.each do |user|
      score = user.score || user.build_score(sales_volume: 0, lease_volume: 0, sales_transactions: 0, lease_transactions: 0)

      case transaction.type_of_transaction
      when 'Sale'
        score.sales_volume += transaction.sale_purchase.to_f
        score.sales_transactions += 1
      when 'Lease'
        score.lease_volume += transaction.sale_purchase.to_f
        score.lease_transactions += 1
      end

      score.save!
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    # TO-DO
    # update scores
    if @transaction.destroy
      redirect_to transactions_path, notice: 'Record was successfully destroyed.'
    else
      redirect_to transactions_path, alert: 'Failed to destroy the record.'
    end
  end

  def filter
    # create function to filter by date, agent, and type of transaction
    start_year, start_month, start_day = params[:start_date].split('-')[0], params[:start_date].split('-')[1], params[:start_date].split('-')[2] if params[:start_date].present?
    closing_year, closing_month, closing_day = params[:closing_date].split('-')[0], params[:closing_date].split('-')[1], params[:closing_date].split('-')[2] if params[:closing_date].present?

    start_date = Date.new(start_year.to_i, start_month.to_i, start_day.to_i) if params[:start_date].present?
    closing_date = Date.new(closing_year.to_i, closing_month.to_i, closing_day.to_i) if params[:closing_date].present?

    if start_date.present?
      @transactions = Transaction.where(current_date: start_date) unless start_date.nil?
    elsif closing_date.present?
      @transactions = Transaction.where(closing_date: closing_date) unless closing_date.nil?
    elsif params[:agent_name].present?
      agent_name_pattern = "#{params[:agent_name].downcase}%"
      @transactions = Transaction.where('LOWER(agent1_name) LIKE ? OR LOWER(agent2_name) LIKE ? OR LOWER(agent3_name) LIKE ?', agent_name_pattern, agent_name_pattern, agent_name_pattern)
    elsif params[:transaction_type].present?
      @transactions = Transaction.where(type_of_transaction: params[:transaction_type])
    else
      @transactions = Transaction.all
    end

    respond_to do |format|
      format.html { render :index }
    end
  end

  private

    def new_transaction_instance
      @transaction = Transaction.new
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def get_type_of_transactions
      @type_of_transactions = Transaction::TYPE_OF_TRANSACTION
    end

    def get_agents_list
      @agents_list = User.select(:id, :name, :last_name).where(role: 'agent').map { |agent| [agent.name + ' ' + agent.last_name, agent.id] }
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:current_date, :agent1_name, :agent2_name, :agent3_name, :agent1_licence, :agent2_licence, :agent3_licence, :type_of_transaction, :property_address, :seller_lessor, :buyer_lessee, :agent_client, :closing_date, :title_escrow_company, :sale_purchase, :bank_deposit, :transaction_fee_amount, :commission_percentage, :agent1_commission_percentage, :agent1_commission_amount, :agent2_commission_percentage, :agent2_commission_amount, :referral_to, :referral_amount, :office_commission_percentage, :office_commission_amount)
    end
end
