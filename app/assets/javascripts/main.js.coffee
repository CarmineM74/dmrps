@app = angular.module('dmrps',['ngResource','ui','interceptorServices'])
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/',
        {controller: MainCtrl, templateUrl: 'assets/main/index.html'}
      )
      .when('/users',
        {controller: UsersCtrl, templateUrl: 'assets/users/index.html'}
      )
      .otherwise(redirectTo: '/')
  ])
  .value('appConfig',{
    serverAddr: 'dm.dev'
    serverPort: ':3000'
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
    

  login: ->
    @$log.log('Attempting login ...')
    @dmSessionSvc.login(@$scope.loginInfo)

  currentUser: ->
    if @dmSessionSvc.currentUser?
      @dmSessioSvc.currentUser
    else
      false

  setupXhr: ->
    @$log.log('setup HTTP default hedaers ...')
    @$http.defaults.headers.common['Content-Type'] = 'application/json'
    @$http.defaults.headers.post['Content-Type'] = 'application/json'
    @$http.defaults.headers.put['Content-Type'] = 'application/json'
    if token = $("meta[name='csrf-token']").attr('content')
      @$http.defaults.headers.post['X-CSRF-Token'] = token
      @$http.defaults.headers.put['X-CSRF-Token'] = token
      @$http.defaults.headers.delete ||= {}
      @$http.defaults.headers.delete['X-CSRF-Token'] = token

