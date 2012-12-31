class @InterventionsCtrl
  @inject: ['$scope','$log','dmInterventionsSvc','$routeParams','$location']
  constructor: (@$scope, @$log, @dmInterventionsSvc,@$routeParams,@$location) ->
    @$scope.interventions = []

    @$scope.$on('dmInterventionsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.editIntervention = angular.bind(this, @editIntervention)
    @$scope.newIntervention = angular.bind(this, @newIntervention)
    @$scope.$on('dmInterventionsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmInterventionsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteIntervention = angular.bind(this, @deleteIntervention)

    @index()

  index: ->
    @$scope.interventions = @dmInterventionsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Interventions#index')
    bootbox.alert("Impossibile recuperare l'elenco degli interventi!")

  editIntervention: (intervention) ->
    @$location.path('interventions/edit/'+intervention.id)

  newIntervention: ->
    @$location.path('interventions/add')

  deleteIntervention: (intervention) ->
    bootbox.confirm("Proseguo con la cancellazione del intervento?",(result) =>
      if result
        @dmInterventionsSvc.destroy(intervention)
    )
  
  deleteSuccess: =>
    bootbox.alert('Intervento rimosso con successo!')
    @index()
