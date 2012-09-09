object @user

attributes :id, :email

node(:error_msg, :if => lambda { |u| !u.valid?}) do |u|
  "Errore durante la creazione dell'utente!"
end

node(:errors) do |u|
  u.errors
end
