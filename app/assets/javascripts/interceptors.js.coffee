angular.module('spinnerServices',[])
  .config(['$httpProvider',($httpProvider) ->
    $httpProvider.responseInterceptors.push('spinnerInterceptor')
    showSpinner = (data, headersGetter) ->
      angular.element('#spinner').show()
      data
    $httpProvider.defaults.transformRequest.push(showSpinner)
  ])
  .factory('spinnerInterceptor',['$rootScope','$q','$log',($rootScope,$q,$log) ->
    i = new SpinnerInterceptor($rootScope,$q,$log)
    return i.interceptor
  ])

class SpinnerInterceptor
  constructor: (@$rootScope, @$q, @$log) ->
    @$log.log('Instantiating SpinnerInterceptor ...')

  interceptor: (promise) =>
    promise.then(@succes,@error)

  stopSpinner: =>
    angular.element('#spinner').hide()
  
  success: (response) =>
    @stopSpinner()
    response

  error: (response) =>
    @stopSpinner()
    @$log.log('HTTP Request ERROR: ' + JSON.stringify(response))
    @$q.reject(response)
