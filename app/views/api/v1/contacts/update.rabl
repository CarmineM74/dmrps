object @contact
attributes *Contact.column_names

node(:error_msg, :if => lambda { |c| !c.valid?}) do |c|
    "Errore durante la modifica dei dati del contatto!"
end

node(:errors, :unless => lambda {|c| c.valid?}) do |c|
    c.errors
end
