class @InterventionsCtrl
  @inject: ['$scope','$log','dialogsSvc','dmInterventionsSvc','$routeParams','$location']
  constructor: (@$scope, @$log, @dialogsSvc,@dmInterventionsSvc,@$routeParams,@$location) ->
    @$scope.interventions = []
    @$scope.query = ''

    @$scope.$on('dmInterventionsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.filter = angular.bind(this, @filter)
    @$scope.editIntervention = angular.bind(this, @editIntervention)
    @$scope.newIntervention = angular.bind(this, @newIntervention)
    @$scope.$on('dmInterventionsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmInterventionsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteIntervention = angular.bind(this, @deleteIntervention)

    @index()

  index: ->
    @$scope.interventions = @dmInterventionsSvc.index('')

  filter: ->
    @$scope.interventions = @dmInterventionsSvc.index(@$scope.query)

  indexFailed: (response) =>
    @$log.log('Error while retrieving Interventions#index')
    @dialogsSvc.alert("Impossibile recuperare l'elenco degli interventi!")

  editIntervention: (intervention) ->
    @$location.path('interventions/edit/'+intervention.id)

  newIntervention: ->
    @$location.path('interventions/add')

  deleteIntervention: (intervention) ->
    @dialogsSvc.messageBox("Cancellazione intervento", "Proseguo con la cancellazione del intervento?",@dialogsSvc.SiNoButtons,
      (result) =>
        if result == 'si'
          @dmInterventionsSvc.destroy(intervention)
    )
  
  deleteSuccess: =>
    @dialogsSvc.alert('Intervento rimosso con successo!')
    @index()
