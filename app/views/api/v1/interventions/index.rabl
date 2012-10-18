collection @interventions
attributes *Intervention.column_names,:totale_ore_lavorate

child :client do
    attributes *Client.column_names
end

child :user do
    attributes *User.column_names
end
