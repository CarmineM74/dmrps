@app.factory('dmSessionSvc',['$rootScope','$resource','$log','$location','appConfig', ($rootScope,$resource,$log,$location,appConfig) ->
	new SessionSvc($rootScope,$resource,$log,$location,appConfig) 
])

class SessionSvc
  constructor: (@$rootScope,$resource,@$log,@$location,@appConfig) ->
    @$log.log('Initializing Session Service ...')
    @currentUser = undefined
    @sessions = $resource('http://:addr:port/api/:api_ver/:path/:subpath/:user_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'sessions'
        subpath: ''
      }
      ,{create: {method: 'POST'}
      ,destroy: {method: 'DELETE'}
      ,authenticated_user: {method: 'GET', params: {subpath: "authenticated_user"}}}
    )
    @$rootScope.$on('Authentication:Failed', @loginFailed)

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

  authenticated_user: ->
    @sessions.authenticated_user(
      (response) => 
        if response.user != ''
          @currentUser = response.user
          @notify('CurrentUser:Success',response.user)
        else
          @currentUser = undefined
          @notify('Logout:Success',response)
      ,(response) => @notify('CurrentUser:Failed',response)
    )

  logout: ->
    @sessions.destroy({user_id: @currentUser.id},
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
         (response) => @loginSuccessful(response) 
      )

  loginSuccessful : (response) ->
    @currentUser = response.user
    @$log.log('[SessionSVC] Login successful: ' + JSON.stringify(@currentUser))
    @notify('Login:Success',@currentUser)

  loginFailed : (event, args) =>
    @$log.log('[SessionSVC] Login failed: ' + JSON.stringify(args.data))
    @currentUser = undefined
    @notify('Login:Failed',args.data)
