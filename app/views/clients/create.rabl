object @client
node(:error_msg, :if => lambda { |c| !c.valid?}) do |c|
  "Errore durante la creazione del cliente!"
end

node(:errors) do |c|
  c.errors
end
