object false
child(@user) do 
  attributes :id, :email, :role 
  node(:permissions) do
    partial('api/v1/permissions/index', object: @user.permissions)
  end
end

node(:error_msg, :if => lambda { |u| @status != :ok }) do |u|
  'Autenticazione fallita!'
end
