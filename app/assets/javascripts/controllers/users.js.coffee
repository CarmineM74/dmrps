class @UsersCtrl
  @inject: ['$scope','$log','dmUsersSvc']
  constructor: (@$scope, @$log, @dmUsersSvc) ->
    @$scope.users = []

