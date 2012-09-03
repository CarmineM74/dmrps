@app.factory('dmSessionSvc',['$rootScope','$resource','$log','$location','appConfig', ($rootScope,$resource,$log,$location,appConfig) ->
	new SessionSvc($rootScope,$resource,$log,$location,appConfig) 
])

class SessionSvc
  constructor: (@$rootScope,$resource,@$log,@$location,@appConfig) ->
    @$log.log('Initializing Session Service ...')
    @currentUser = undefined
    @sessions = $resource('http://:serverAddr:port/:path/:user_id'
      ,{serverAddr: appConfig.serverAddr, port: appConfig.serverPort, path: 'sessions'}
      ,{create: {method: 'POST'}
      ,destroy: {method: 'DELETE'}}
    )
    @$rootScope.$on('Authentication:Failed', @authenticationFailed)

  notify: (name, args) ->
    @$rootScope.$broadcast('dmSessionSvc:'+name,args)

  authenticatedOrRedirect: (path) ->
    @$log.log('Checking authentication ...')
    if @currentUser?
      return true
    else
      @$log.log('Not authenticated. Redirecting to: ' + path)
      @$location.path(path)
      return false

  authenticationFailed: (event, args) =>
    @currentUser = undefined
    @notify('Logout:Success',args)

  logout: ->
    user.$destroy({user_id: @currentUser.id},
      (response) => @notify('Logout:Success',response),
      (response) => @notify('Logout:Failed',response)
    )
    @currentUser = undefined

  login: (user) ->
    @$log.log('Login with ' + JSON.stringify(user))
    if @currentUser?
      @notify('Login:Success',@currentUser)
    else
      @sessions.create({email: user.email, password: user.password},
         (response) => @loginSuccessful(response), 
         (response) => @loginFailed(response)
      )

  loginSuccessful : (response) ->
    @currentUser = response.user
    @$log.log('Login successful: ' + JSON.stringify(@currentUser))
    @notify('Login:Success',@currentUser)

  loginFailed : (response) ->
    @$log.log('Login failed: ' + JSON.stringify(response))
    @currentUser = undefined
    @notify('Login:Failed',response)
