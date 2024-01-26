require "prawn"

class ScoresController < ApplicationController
  before_action :set_format_to_html

  def index
    @agents = User.where(role: 'agent').map { |agent| [agent.name + ' ' + agent.last_name, agent.id] }

    # @transactions = TransactionUser.includes(:user, transaction_record: :csv_file).all
    @users_with_scores = User.calculate_relative_position
  end

  def generate_report
    user_id = params[:agent]
    @selected_agent = User.find(user_id) if user_id.present?

    @users_with_scores = @selected_agent ? [@selected_agent.class.calculate_relative_position] : User.calculate_relative_position

    respond_to do |format|
      format.pdf do
        render pdf: "score_report",
               type: "application/pdf",
               template: "scores/report.pdf.erb",
               layout: "application.html.erb"
      end
    end
  end

  def report

  end

  def set_format_to_html
    request.format = 'html'
  end
end
