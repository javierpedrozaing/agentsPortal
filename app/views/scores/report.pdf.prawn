<%= prawn_document(filename: "my-file.pdf", disposition: "attachment") do |pdf|
  pdf.text "Users with Scores Report", size: 20, align: :center
  move_down 20

  if @selected_agent
    pdf.text "Selected Agent: #{@selected_agent.name}", size: 16, style: :bold
    move_down 10
  end

  @users_with_scores.each_with_index do |user_with_score, index|
    pdf.text "#{index + 1}. #{user_with_score[:user].name}"
    pdf.text "   Score: #{user_with_score[:score]}"
    pdf.text "   Total Transactions: #{user_with_score[:user].score&.sales_transactions.to_i}"
    move_down 10
  end
end %>
