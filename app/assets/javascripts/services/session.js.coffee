@app.factory('dmSessionSvc',['$rootScope','$resource','$log','$location','appConfig', ($rootScope,$resource,$log,$location,appConfig) ->
	new SessionSvc($rootScope,$resource,$log,$location,appConfig) 
])

class SessionSvc
  constructor: (@$rootScope,$resource,@$log,@$location,@appConfig) ->
    @$log.log('Initializing Session Service ...')
    @current_user = undefined
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
    if @current_user?
      return true
    else
      @$log.log('Not authenticated. Redirecting to: ' + path)
      @$location.path(path)
      return false

  authenticationFailed: (response) =>
    @current_user = undefined
    @notify('Logout:Success',response)

  logout: ->
    user.$destroy({user_id: @current_user.id},
      (response) => @notify('Logout:Success',response),
      (response) => @notify('Logout:Failed',response)
    )
    @current_user = undefined

  login: (user) ->
    @$log.log('Login with ' + JSON.stringify(user))
    if @current_user?
      @notify('Login:Success',@current_user)
    else
      @sessions.create({email: user.email, password: user.password},
         (response) => @loginSuccessful(response), 
         (response) => @loginFailed(response)
      )

  loginSuccessful : (response) ->
    @$log.log('Login successful: ' + JSON.stringify(response))
    @current_user = response
    @notify('Login:Success',@current_user)

  loginFailed : (response) ->
    @$log.log('Login failed: ' + JSON.stringify(response))
    @current_user = undefined
    @notify('Login:Failed',response)
