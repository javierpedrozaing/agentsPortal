class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
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
          # Assuming your CSV has columns in the same order as your transactions table
          transaction_params = row.to_h
          transaction_params['user_id'] = current_user.id # Set the user_id based on the current user

          Transaction.create!(transaction_params)
        end

        redirect_to transactions_path, notice: 'CSV file imported successfully.'
      rescue CSV::MalformedCSVError, CSV::Row::UnknownHeaderError, ActiveRecord::RecordInvalid => e
        redirect_to new_transaction_path, alert: "Error importing CSV file: #{e.message}"
      end
    else
      redirect_to new_transaction_path, alert: 'Please select a CSV file.'
    end
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
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
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:current_date, :agent1_name, :agent2_name, :agent3_name, :type_of_transaction, :property_address, :seller_lessor, :buyer_lessee, :agent_client, :closing_date, :title_escrow_company, :sale_purchase, :bank_deposit, :transaction_fee_amount, :commission_percentage, :agent1_commission_percentage, :agent1_commission_amount, :agent2_commission_percentage, :agent2_commission_amount, :referral_to, :referral_amount, :office_commission_percentage, :office_commission_amount, :user_id)
    end
end
