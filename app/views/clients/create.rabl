object @client
node(:error_msg, :if => lambda { |u| !u.valid?}) do |u|
  "Errore durante la creazione del cliente!"
end

node(:errors) do |u|
  u.errors
end
