@app = angular.module('dmrps',['ngResource','ui.jq','ui.bootstrap','ui.date','ui.select2','interceptorServices','directivesService','dmrpsFilters','ngCookies'])
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
      .when('/activities',
        {controller: ActivitiesCtrl, templateUrl: 'assets/activities/index.html'}
      )
      .otherwise(redirectTo: '/')
  ])
  .value('appConfig',{
    serverAddr: '94.138.187.17'
    #serverAddr: 'casamia.no-ip.biz'
    #serverAddr: '192.168.1.101'
    serverPort: ':80'
    api_ver: 'v1'
  })

class @MainNavCtrl
  @inject: ['$scope','$log','$location','$http','dialogsSvc','sessionSvc','$cookieStore']
  constructor: (@$scope,@$log,@$location,@$http,@dialogsSvc,@sessionSvc,@$cookies) ->
    @$log.log('Bootstrapping application ...')
    @$log.log(@$cookies)
    @setupXhr()

    @$scope.loginInfo = {email: '', password: ''}
    @$scope.login = angular.bind(this,@login)
    @$scope.logout = angular.bind(this,@logout)
    @$scope.$on('SessionSvc:Login:Success',@loginSuccessful)
    @$scope.$on('SessionSvc:Login:Failed',@loginFailed)
    @$scope.$on('SessionSvc:Logout:Success',@logoutSuccessful)
    @$scope.$on('SessionSvc:Logout:Failed',@logoutFailed)

    @$scope.$on('SessionSvc:CurrentUser:Authenticated',@loginSuccessful)
    @$scope.$on('SessionSvc:CurrentUser:NotAuthenticated',@notAuthenticated)
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
    @dialogsSvc.alert(args.error_msg)
    @$location.path('/')

  logout: ->
    @$log.log('[Main] Logout ...')
    @sessionSvc.logout()
    @$location.path('/')

  logoutSuccessful: (event, args) =>
    @$log.log('[Main] Logout successful')

  logoutFailed: (event, args) =>
    @$log.log('[Main] Logout failed: ' + JSON.stringify(args))
    @dialogsSvc.alert('Errore durante il logout!')

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

