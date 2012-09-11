object @client
attributes :id, :ragione_sociale, :indirizzo, :citta, :cap, :provincia, :partita_iva, :codice_fiscale
node(:error_msg, :if => lambda { |c| !c.valid?}) do |c|
  "Errore durante la creazione del cliente!"
end

node(:errors, :unless => lambda {|c| c.valid?}) do |c|
  c.errors
end
