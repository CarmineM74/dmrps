object false
unless @user.nil?
  child(@user) { attributes :id, :email }
else
  node(:user) { '' }
end
