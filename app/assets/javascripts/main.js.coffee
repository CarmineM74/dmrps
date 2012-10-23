@app = angular.module('dmrps',['ngResource','ui','interceptorServices','directivesService','dmrpsFilters'])
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/',
        {controller: MainCtrl, templateUrl: 'assets/main/index.html'}
      )
      .when('/users',
        {controller: UsersCtrl, templateUrl: 'assets/users/index.html'}
      )
      .when('/clients',
        {controller: ClientsCtrl, templateUrl: 'assets/clients/index.html'}
      )
      .when('/locations/:client_id',
        {controller: LocationsCtrl, templateUrl: 'assets/locations/index.html'}
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
    serverAddr: 'dm.dev'
    #serverAddr: '192.168.1.95'
    serverPort: ':3000'
    api_ver: 'v1'
  })

class @MainCtrl
  @inject: ['$scope','$log','$location','$http','dmSessionSvc']
  constructor: (@$scope,@$log,@$location,@$http,@dmSessionSvc) ->
    @$log.log('Bootstrapping application ...')
    @setupXhr()

    @$scope.loginInfo = {email: '', password: ''}
    @$scope.currentUser = angular.bind(this,@currentUser)
    @$scope.login = angular.bind(this,@login)
    @$scope.logout = angular.bind(this,@logout)
    @$scope.$on('dmSessionSvc:Login:Success',@loginSuccessful)
    @$scope.$on('dmSessionSvc:Login:Failed',@loginFailed)
    @$scope.$on('dmSessionSvc:Logout:Success',@logoutSuccessful)
    @$scope.$on('dmSessionSvc:Logout:Failed',@logoutFailed)

  login: ->
    @$log.log('[Main] Attempting login ...')
    @dmSessionSvc.login(@$scope.loginInfo)

  loginSuccessful: (event, args) =>
    @$log.log('[Main] Login successful ' + JSON.stringify(args))

  loginFailed: (event, args) =>
    @$log.log('[Main] Login failed')
    bootbox.alert(args.error_msg)

  logout: ->
    @$log.log('[Main] Logout ...')
    @dmSessionSvc.logout()

  logoutSuccessful: (event, args) =>
    @$log.log('[Main] Logout successful')

  logoutFailed: (event, args) =>
    @$log.log('[Main] Logout failed: ' + JSON.stringify(args))
    bootbox.alert('Errore durante il logout!')

  currentUser: ->
    if @dmSessionSvc.currentUser?
      @$log.log('[Main] Currently logged in as ' + @dmSessionSvc.currentUser.email)
      @dmSessionSvc.currentUser
    else
      @$log.log('[Main] Not logged in')
      false

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

