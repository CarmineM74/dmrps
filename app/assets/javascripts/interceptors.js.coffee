angular.module('interceptorServices',[])
  .config(['$httpProvider',($httpProvider) ->
    
    $httpProvider.responseInterceptors.push('spinnerInterceptor')
    $httpProvider.responseInterceptors.push('authInterceptor')

    showSpinner = (data, headersGetter) ->
      angular.element('#spinner').show()
      data
    $httpProvider.defaults.transformRequest.push(showSpinner)
  ])
  .factory('spinnerInterceptor',['$rootScope','$q','$log',($rootScope,$q,$log) ->
    i = new SpinnerInterceptor($rootScope,$q,$log)
    return i.interceptor
  ])
  .factory('authInterceptor',['$rootScope','$q','$log',($rootScope,$q,$log) ->
    i = new AuthInterceptor($rootScope,$q,$log)
    return i.interceptor
  ])

class AuthInterceptor
  constructor: (@$rootScope, @$q, @$log) ->
    @$log.log('Instantiating AuthInterceptor ...')

  interceptor: (promise) =>
    promise.then(@succces,@error)

  success: (response) =>
    response

  error: (response) =>
    if response.status == 401
      @$log.log('[AuthInterceptor] Authentication failed: ' + JSON.stringify(response))
      deferred = @$q.defer()
      @$rootScope.$broadcast('Authentication:Failed',response)
      return deferred.promise
    else
      @$q.reject(response)

class SpinnerInterceptor
  constructor: (@$rootScope, @$q, @$log) ->
    @$log.log('Instantiating SpinnerInterceptor ...')

  interceptor: (promise) =>
    promise.then(@success,@error)

  stopSpinner: =>
    angular.element('#spinner').hide()
  
  success: (response) =>
    @$log.log(response)
    @stopSpinner()
    response

  error: (response) =>
    @stopSpinner()
    @$log.log('[SpinnerInterceptor] HTTP Request ERROR: ' + JSON.stringify(response))
    @$q.reject(response)
