object @client
attributes :id, :ragione_sociale, :indirizzo, :cap, :citta, :provincia, 
            :partita_iva, :codice_fiscale, :tipo_contratto, :costo,
            :inizio, :fine, :diritto_di_chiamata, :costo_diritto_chiamata, :nr_contratto
node(:error_msg, :if => lambda { |c| !c.valid?}) do |c|
    "Errore durante la modifica dei dati del cliente!"
end

node(:errors, :unless => lambda {|c| c.valid?}) do |c|
    c.errors
end
