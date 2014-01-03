object @user

attributes :id, :email, :role, :name

node :permissions do |u|
  partial('api/v1/permissions/index', object: u.permissions)
end
