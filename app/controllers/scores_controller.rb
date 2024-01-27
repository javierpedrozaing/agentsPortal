class ScoresController < ApplicationController

  def index
    @agents = User.where(role: 'agent').map { |agent| [agent.name + ' ' + agent.last_name, agent.id] }
    @users_with_scores = User.calculate_relative_position
  end

  # def report_pdf
  #   user_id = params[:agent]
  #   @selected_agent = User.find(user_id) if user_id.present?

  #   @users_with_scores = @selected_agent ? [@selected_agent.class.calculate_relative_position] : User.calculate_relative_position

  #   respond_to do |format|
  #     format.html
  #     format.pdf do
  #         render pdf: "Report No. #{@selected_agent.id}",
  #         page_size: 'A4',
  #         template: "scores/report_pdf.html.erb",
  #         layout: "pdf.html",
  #         orientation: "Landscape",
  #         lowquality: true,
  #         zoom: 1,
  #         dpi: 75
  #     end
  #   end
  # end
end
