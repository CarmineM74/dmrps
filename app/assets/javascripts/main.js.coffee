@app = angular.module('dmrps',['ngResource','ui','spinnerServices'])
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
  @inject: ['$scope','$log','$location','$http']
  constructor: (@$scope,@$log,@$location,@$http) ->
    @$log.log('Bootstrapping application ...')
    @setupXhr()
    @$scope.waiting = false
    @$scope.$on('Spinner:Show', => @$scope.waiting = true)
    @$scope.$on('Spinner:Hide', => @$scope.waiting = false)

  
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

