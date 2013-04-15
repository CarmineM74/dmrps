object @activity

attributes *Activity.column_names

node(:error_msg, :if => lambda { |a| !a.valid? }) do |a|
  "Errore durante la creazione dell'attivita'!"
end

node(:errors, :unless => lambda { |a| a.valid? }) do |a|
  a.errors
end

