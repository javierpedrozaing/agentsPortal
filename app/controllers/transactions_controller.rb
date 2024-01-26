require 'csv'

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :get_type_of_transactions, only: %i[ new edit ]
  before_action :get_agents_list, only: %i[ new edit ]

  # GET /transactions or /transactions.json
  def index
    @transaction = Transaction.new
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  def import
    file = params[:transaction][:csv_file]

    if file.present?
      data = file.read

      begin
        CSV.parse(data, headers: true) do |row|
          begin
            transaction_params = row.to_h.transform_values { |value| value.present? ? value : "-" }
            transaction_params['user_id'] = current_user.id

            agent1_name, agent1_last_name = transaction_params['agent1_name'].split(' ')
            agent2_name, agent2_last_name = transaction_params['agent2_name'].split(' ')
            agent3_name, agent3_last_name = transaction_params['agent3_name'].split(' ')

            user1 = User.where('lower(name) = ? AND lower(last_name) = ?', agent1_name, agent1_last_name)
            user2 = User.where('lower(name) = ? AND lower(last_name) = ?', agent2_name, agent2_last_name)
            user3 = User.where('lower(name) = ? AND lower(last_name) = ?', agent3_name, agent3_last_name)

            @transaction = Transaction.create!(transaction_params)
            @transaction.users << user1 << user2 << user3

            update_scores(@transaction, [@user1, @user2, @user3])
          rescue ActiveRecord::RecordInvalid => e
            # Handle record invalid exception for a specific row
            Rails.logger.error("Error creating transaction: #{e.message}")
          end
        end

        redirect_to transactions_path, notice: 'CSV file imported successfully.'
      rescue CSV::MalformedCSVError => e
        redirect_to new_transaction_path, alert: "Error importing CSV file: #{e.message}"
      end
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
    return unless transaction.present? && users.present?

    users.each do |user|
      score = user.score || user.build_score(sales_volume: 0, lease_volume: 0, sales_transactions: 0, lease_transactions: 0)

      case transaction.type_of_transaction
      when 'Sale'
        score.sales_volume += transaction.transaction_fee_amount.to_f
        score.sales_transactions += 1
      when 'Lease'
        score.lease_volume += transaction.transaction_fee_amount.to_f
        score.lease_transactions += 1
      end

      score.save!
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    if @transaction.destroy
      redirect_to transactions_path, notice: 'Record was successfully destroyed.'
    else
      redirect_to transactions_path, alert: 'Failed to destroy the record.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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
      params.require(:transaction).permit(:current_date, :agent1_name, :agent2_name, :agent3_name, :type_of_transaction, :property_address, :seller_lessor, :buyer_lessee, :agent_client, :closing_date, :title_escrow_company, :sale_purchase, :bank_deposit, :transaction_fee_amount, :commission_percentage, :agent1_commission_percentage, :agent1_commission_amount, :agent2_commission_percentage, :agent2_commission_amount, :referral_to, :referral_amount, :office_commission_percentage, :office_commission_amount)
    end
end
