module TransactionsHelper
  def agents_list
    agents = User.where(role: 'agent').pluck(:id, :name, :last_name)
  options_for_select(agents.map { |agent| ["#{agent[1]} #{agent[2]}", agent[0]] } )
  end
end
