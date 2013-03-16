object @location
attributes :id, :descrizione, :indirizzo, :citta, :cap, :provincia, :telefono, :fax
node(:error_msg, :if => lambda { |l| !l.valid?}) do |l|
  "Errore durante la creazione della sede!"
end

node(:errors, :unless => lambda {|l| l.valid?}) do |l|
  l.errors
end
