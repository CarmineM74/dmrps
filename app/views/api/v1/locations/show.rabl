object @location
attributes :id, :client_id, 
            :descrizione, :indirizzo, :cap, :citta, :provincia

node :client do |l|
  partial('api/v1/clients/show', object: l.client)
end
