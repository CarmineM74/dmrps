object @user

attributes :id, :email, :role

node :permissions do |u|
  partial('api/v1/permissions/index', object: u.permissions)
end
