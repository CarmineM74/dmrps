object @user

attributes :id, :email, :name

node(:error_msg, :if => lambda { |u| !u.valid?}) do |u|
  "Errore durante la creazione dell'utente!"
end

node(:errors, :unless => lambda {|u| u.valid?}) do |u|
    u.errors
end
