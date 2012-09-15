object @location
node(:error_msg, :if => lambda { |l| !l.valid?}) do |l|
    "Errore durante la modifica dei dati della locazione!"
end

node(:errors, :unless => lambda {|l| l.valid?}) do |l|
    l.errors
end
