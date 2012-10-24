collection @interventions
attributes *Intervention.column_names,:totale_ore_lavorate

child :client do
    attributes *Client.column_names
end

child :user do
    attributes *User.column_names
end

node :location do |i|
    partial('api/v1/locations/location', object: i.locations.first)
end
