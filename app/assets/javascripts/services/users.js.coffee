@app.factory('dmUsersSvc',['$rootScope','$resource','$log','appConfig', ($rootScope,$resource,$log,appConfig) ->
	new UsersSvc($rootScope,$resource,$log,appConfig) 
])

class UsersSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('Initializing Userss Service ...')
    @users = @$resource('http://:serverAddress:port/:path/:user_id'
      ,{serverAddress: appConfig.serverAddr, port: appConfig.serverPort, path: 'users'}
      ,{index: {method: 'GET', isArray: true}
      ,create: {method: 'POST'}
      ,update: {method: 'PUT'}
      ,destroy: {method: 'DELETE'}}
    )

  notify: (name,args) ->
    @$rootScope.$broadcast('dmUsersSvc:'+name,args)

  destroy: (user) ->
    user.$destroy({user_id: user.id},
      (response) => @notify('Destroy:Success',response),
      (response) => @notify('Destroy:Failure',response)
    )

  save: (user) ->
    if user.id?
      user.$update({user_id: user.id},
        (response) => @notify('Update:Success',response)
        (response) => @notify('Update:Failure',response)
      )
    else
      c = new @users(user)
      c.$save(
        (response) => @notify('Create:Success',response), 
        (response) => @notify('Create:Failure',response)
      )  

  index: ->
    @$log.log('Fetching users from backend ...')
    @users.index(
      (response) => @notify('Index:Success',response),
      (response) => @notify('dmUserSvc:Index:Failure',response)
    )
