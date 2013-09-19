object @location
attributes :id, :client_id, 
            :descrizione, :indirizzo, :cap, :citta, :provincia, :telefono, :fax
node(:error_msg, :if => lambda { |l| !l.valid?}) do |l|
    "Errore durante la modifica dei dati della locazione!"
end

node(:errors, :unless => lambda {|l| l.valid?}) do |l|
    l.errors
end
