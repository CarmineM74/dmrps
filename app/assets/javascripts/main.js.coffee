@app = angular.module('dmrps',['ngResource','ui'])
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
    serverAddr: '192.168.1.95'
    serverPort: ':3000'
  })

class @MainCtrl
  @inject: ['$scope','$log','$location','$http']
  constructor: (@$scope,@$log,@$location,@$http) ->
    @$log.log('Bootstrapping application ...')
    @setupXhr()
    @$scope.waiting = false
  
  setupXhr: ->
    @$log.log('setup HTTP default hedaers ...')
    @$http.defaults.headers.common['Content-type'] = 'application/json'
    @$http.defaults.headers.post['Content-type'] = 'application/json'
    @$http.defaults.headers.put['Content-type'] = 'application/json'
    if token = $("meta[name='csrf-token']").attr('content')
      @$http.defaults.headers.post['X-CSRF-Token'] = token
      @$http.defaults.headers.put['X-CSRF-Token'] = token
      @$http.defaults.headers.delete ||= {}
      @$http.defaults.headers.delete['X-CSRF-Token'] = token

