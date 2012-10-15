object @intervention
attributes *Intervention.column_names, :location_ids

node(:error_msg, :if => lambda { |l| !l.valid?}) do |l|
  "Errore durante la creazione dell'intervento!"
end

node(:errors, :unless => lambda {|l| l.valid?}) do |l|
  l.errors
end
