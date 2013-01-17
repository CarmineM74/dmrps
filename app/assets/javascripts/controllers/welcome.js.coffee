class @WelcomeCtrl
  @inject: ['$scope','$log']
  constructor: (@$scope, @$log) ->
    @$log.log("[WelcomeCtrl] Ready")


