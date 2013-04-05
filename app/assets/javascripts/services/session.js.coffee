@app.factory('sessionSvc',['$rootScope','$resource','$log','$location','appConfig', ($rootScope,$resource,$log,$location,appConfig) ->
	new SessionSvc($rootScope,$resource,$log,$location,appConfig) 
])

class SessionSvc
  constructor: (@$rootScope,$resource,@$log,@$location,@appConfig) ->
    @$log.log('Initializing Session Service ...')
    @currentUser = undefined
    @$rootScope.currentUser = @currentUser

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
      ,authenticated_user: {method: 'GET', params: {subpath: "authenticated_user.json"}}}
    )

    @$rootScope.$on('Authentication:Failed', @loginFailed)

    # Installiamo a livello globale il metodo "can" per il controllo
    # delle autorizzazioni utente
    @$rootScope.can = @can

  notify: (name, args) ->
    @$rootScope.$broadcast('SessionSvc:'+name,args)

  checkCanOptions: (opts) ->
    if opts?
      #@$log.log('Options: ' + JSON.stringify(opts))
      if opts.fail_and_logout
        bootbox.alert("Autorizzazioni insufficienti per eseguire l'operazione!")
        @$location.path('/')
        @logout()

  can: (rule,opts) =>
    if !@currentUser?
      #@checkCanOptions(opts)
      return false
    else
      if @currentUser.role == 'admin'
        return true
      else
        # @$log.log('Checking permissions for rule: ' + rule)
        allowed_to = [] 
        allowed_to.push permission.rule for permission in @currentUser.permissions when permission.status is true
        #@$log.log('User is allowed to: ' + allowed_to)
        authorized = (rule in allowed_to)
        if !authorized
          @checkCanOptions(opts)
          return false
        else
          return true

  authenticated_user: ->
    @sessions.authenticated_user(
      (response) => 
        if response.user != ''
          @currentUser = response.user
          @$rootScope.currentUser = @currentUser
          @notify('CurrentUser:Authenticated',response.user)
        else
          @currentUser = undefined
          @$rootScope.currentUser = @currentUser
          @notify('CurrentUser:NotAuthenticated',response)
      ,(response) => @notify('CurrentUser:Failed',response)
    )

  logout: ->
    @sessions.destroy({user_id: @currentUser.id},
      (response) => @notify('Logout:Success',response),
      (response) => @notify('Logout:Failed',response)
    )
    @currentUser = undefined
    @$rootScope.currentUser = @currentUser

  login: (user) ->
    @$log.log('Login with ' + JSON.stringify(user))
    if @currentUser?
      @$rootScope.currentUser = @currentUser
      @notify('Login:Success',@currentUser)
    else
      @sessions.create({email: user.email, password: user.password},
         (response) => @loginSuccessful(response) 
      )

  loginSuccessful : (response) ->
    @currentUser = response.user
    @$rootScope.currentUser = @currentUser
    @$log.log('[SessionSVC] Login successful: ' + JSON.stringify(@currentUser))
    @notify('Login:Success',@currentUser)

  loginFailed : (event, args) =>
    @$log.log('[SessionSVC] Login failed: ' + JSON.stringify(args.data))
    @currentUser = undefined
    @$rootScope.currentUser = @currentUser
    @notify('Login:Failed',args.data)
