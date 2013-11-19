object false
unless @user.nil?
  child(@user) do 
    attributes :id, :email, :role
    node(:permissions) do
      partial('api/v1/permissions/index', object: @user.permissions)
    end
  end
else
  node(:user) { '' }
end
