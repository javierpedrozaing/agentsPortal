module ApplicationHelper
  def self.cities_list(country)
    cities = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/cities", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.states_list_by_country(country)
    states = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/states", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.cities_list_by_state_and_country(state, country = 'US' )
    states = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/states/#{state}/cities", {
      headers: headers,
      debug_output: STDOUT,
    })
  end

  def self.headers
    { 'X-CSCAPI-KEY' => "YVdlcWh4OEFsb1kxSXV6RFVwaU84QUNmNWtsSHJla0FTUUNDc1Y0cA==" }
  end
end
