object false
unless @user.nil?
  child(@user) { attributes :id, :email, :role }
else
  node(:user) { '' }
end
