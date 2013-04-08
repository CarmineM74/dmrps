@app = angular.module('dmrps',['ngResource','ui','ui.bootstrap','interceptorServices','directivesService','dmrpsFilters','ngCookies'])
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/',
        {controller: WelcomeCtrl, templateUrl: 'assets/main/index.html'}
      )
      .when('/users',
        {controller: UsersCtrl, templateUrl: 'assets/users/index.html'}
      )
      .when('/clients',
        {controller: ClientsCtrl, templateUrl: 'assets/clients/index.html'}
      )
      .when('/clients/add',
        {controller: EditClientCtrl, templateUrl: 'assets/clients/edit_client.html'}
      )
      .when('/clients/edit/:client_id',
        {controller: EditClientCtrl, templateUrl: 'assets/clients/edit_client.html'}
      )
      .when('/locations/add/:client_id',
        {controller: EditLocationCtrl, templateUrl: 'assets/locations/edit_location.html'}
      )
      .when('/locations/edit/:client_id/:location_id',
        {controller: EditLocationCtrl, templateUrl: 'assets/locations/edit_location.html'}
      )
      .when('/interventions',
        {controller: InterventionsCtrl, templateUrl: 'assets/interventions/index.html'}
      )
      .when('/interventions/add',
        {controller: EditInterventionCtrl, templateUrl: 'assets/interventions/intervention-edit.html'}
      )
      .when('/interventions/edit/:intervention_id',
        {controller: EditInterventionCtrl, templateUrl: 'assets/interventions/intervention-edit.html'}
      )
      .otherwise(redirectTo: '/')
  ])
  .value('appConfig',{
    #serverAddr: 'dm.dev'
    serverAddr: '192.168.1.98'
    serverPort: ':3000'
    api_ver: 'v1'
  })

class @MainNavCtrl
  @inject: ['$scope','$log','$location','$http','sessionSvc','$cookieStore']
  constructor: (@$scope,@$log,@$location,@$http,@sessionSvc,@$cookies) ->
    @$log.log('Bootstrapping application ...')
    @$log.log(@$cookies)
    @setupXhr()

    @$scope.loginInfo = {email: '', password: ''}
    @$scope.login = angular.bind(this,@login)
    @$scope.logout = angular.bind(this,@logout)
    @$scope.$on('sessionSvc:Login:Success',@loginSuccessful)
    @$scope.$on('sessionSvc:Login:Failed',@loginFailed)
    @$scope.$on('sessionSvc:Logout:Success',@logoutSuccessful)
    @$scope.$on('sessionSvc:Logout:Failed',@logoutFailed)

    @$scope.$on('sessionSvc:CurrentUser:Authenticated',@loginSuccessful)
    @$scope.$on('sessionSvc:CurrentUser:NotAuthenticated',@notAuthenticated)
    @sessionSvc.authenticated_user()

  notAuthenticated: =>
    @$location.path('/')

  login: ->
    @$log.log('[Main] Attempting login ...')
    @sessionSvc.login(@$scope.loginInfo)

  loginSuccessful: (event, args) =>
    @$log.log('[Main] Login successful ' + JSON.stringify(args))

  loginFailed: (event, args) =>
    @$log.log('[Main] Login failed')
    bootbox.alert(args.error_msg)
    @$location.path('/')

  logout: ->
    @$log.log('[Main] Logout ...')
    @sessionSvc.logout()
    @$location.path('/')

  logoutSuccessful: (event, args) =>
    @$log.log('[Main] Logout successful')

  logoutFailed: (event, args) =>
    @$log.log('[Main] Logout failed: ' + JSON.stringify(args))
    bootbox.alert('Errore durante il logout!')

  setupXhr: ->
    @$log.log('[Main] setup HTTP default hedaers ...')
    @$http.defaults.headers.common['Content-Type'] = 'application/json'
    @$http.defaults.headers.post['Content-Type'] = 'application/json'
    @$http.defaults.headers.put['Content-Type'] = 'application/json'
    if token = $("meta[name='csrf-token']").attr('content')
      @$http.defaults.headers.post['X-CSRF-Token'] = token
      @$http.defaults.headers.put['X-CSRF-Token'] = token
      @$http.defaults.headers.delete ||= {}
      @$http.defaults.headers.delete['X-CSRF-Token'] = token

