object @intervention
attributes *Intervention.column_names,:totale_ore_lavorate

node :client do |i|
    partial('api/v1/clients/client', object: i.locations.first.client)
end

child :user do
    attributes *User.column_names
end

node :location do |i|
   partial('api/v1/locations/location', object: i.locations.first )
end
