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
    promise.then(@stopSpinner,@stopSpinner)

  stopSpinner: (response) =>
    angular.element('#spinner').hide()
    response
