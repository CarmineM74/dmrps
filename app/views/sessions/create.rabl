object false
child(@user) { attributes :id, :email, :role } 

node(:error_msg, :if => lambda { |u| @status != :ok }) do |u|
  'Autenticazione fallita!'
end
