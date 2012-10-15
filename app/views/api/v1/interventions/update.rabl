object @intervention
node(:error_msg, :if => lambda { |l| !l.valid?}) do |l|
    "Errore durante la modifica dei dati dell'intervento!"
end

node(:errors, :unless => lambda {|l| l.valid?}) do |l|
    l.errors
end
