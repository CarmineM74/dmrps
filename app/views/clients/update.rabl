object @client
node(:error_msg, :if => lambda { |c| !c.valid?}) do |u|
    "Errore durante la modifica dei dati del cliente!"
end

node(:errors) do |u|
    u.errors
end
