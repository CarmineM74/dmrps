@app.factory('dmUsersSvc',['$rootScope','$resource','$log','appConfig', ($rootScope,$resource,$log,appConfig) ->
	new UsersSvc($rootScope,$resource,$log,appConfig) 
])

class UsersSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('Initializing Users Service ...')
    @users = @$resource('http://:addr:port/api/:api_ver/:path/:user_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'users'
      }
      ,{index: {method: 'GET', isArray: true}
      ,create: {method: 'POST'}
      ,update: {method: 'PUT'}
      ,destroy: {method: 'DELETE'}}
    )

  notify: (name,args) ->
    #@$log.log('Broadcasting : ' + name + ' with ' + JSON.stringify(args))
    @$rootScope.$broadcast('dmUsersSvc:'+name,args)

  destroy: (user) ->
    user.$destroy({user_id: user.id},
      (response) => @notify('Destroy:Success',response),
      (response) => @notify('Destroy:Failure',response)
    )

  save: (user) ->
    if user.id?
      user.$update({user_id: user.id},
        (response) => @notify('Save:Success',response)
        (response) => @notify('Save:Failure',response)
      )
    else
      c = new @users(user)
      c.$save(
        (response) => @notify('Save:Success',response), 
        (response) => @notify('Save:Failure',response)
      )  

  index: ->
    @users.index(
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )
