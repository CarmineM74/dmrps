class @UsersCtrl
  @inject: ['$scope','$log','dmUsersSvc']
  constructor: (@$scope, @$log, @dmUsersSvc) ->
    @$scope.users = []

    @$scope.$on('dmUsersSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)

  index: ->
    @$scope.users = @dmUsersSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Users#index')
    alert('Cannot retrieve users index!')

