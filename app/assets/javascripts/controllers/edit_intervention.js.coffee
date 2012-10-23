class @EditInterventionCtrl
  @inject: ['$scope','$log','dmInterventionsSvc','dmClientsSvc','dmLocationsSvc','$routeParams','$location']
  constructor: (@$scope, @$log, @dmInterventionsSvc,@dmClientsSvc,@dmLocationsSvc,@$routeParams,@$location) ->
    @$scope.errors = []
    @$scope.clients = []
    @$scope.selectedClient = undefined
    @$scope.locations = []
    @$scope.selectedLocation = undefined

    @$scope.$on('dmClientsSvc:Index:Failure',@clientsRetrievalFailed)
    @$scope.$on('dmLocationsSvc:Index:Failure',@locationsRetrievalFailed)

    @$scope.$on('dmInterventionsSvc:Get:Failure',@interventionRetrievalFailed) 
    @$scope.$on('dmInterventionsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmInterventionsSvc:Save:Failure',@reqFailed)
    @$scope.saveIntervention = angular.bind(this, @saveIntervention)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.clientChanged = angular.bind(this, @clientChanged)
    @$scope.locationChanged = angular.bind(this, @locationChanged)

    if @$routeParams.intervention_id?
      @$scope.intervention = @dmInterventionsSvc.get(@$routeParams.intervention_id)
      @$scope.originalIntervention = angular.copy(@$scope.intervention)
    else
      @$scope.intervention = undefined
      @$scope.originalIntervention = undefined

  interventionRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving intervention: ' + JSON.stringify(response))
    bootbox.alert("Si e' verificato un errore durante il recupero dell'intervento!")
    @$location.path('/interventions')

  clientsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving clients list')
    bootbox.alert("Si e' verificato un errore durante il recupero dell'elenco clienti!")

  locationsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving locations list')
    bootbox.alert("Si e' verificato un errore durante il recupero dell'elenco sedi per il cliente selezionato!")

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    unless @$scope.originalIntervention?
        return true
    @$log.log('Original: ' + JSON.stringify(@$scope.originalIntervention))
    @$log.log('Selected: ' + JSON.stringify(@$scope.selectedIntervention))
    if angular.equals(@$scope.originalIntervention,@$scope.selectedIntervention)
      false
    else
      true

  clientChanged: ->
    @$log.log("Client: " + @$scope.selectedClient.ragione_sociale)
    #@$log.log("Fetching locations for " + @$scope.selectedClient.ragione_sociale)
    #@$scope.locations = @dmLocationsSvc.index(@$scope.selectedClient.id)

  locationChanged: ->
    @$log.log("Location selected: " + @$scope.selectedLocation.descrizione)
    @$scope.selectedIntervention.location_id = @$scope.selectedLocation.id

  saveIntervention: (intervention) ->
    @dmInterventionsSvc.save(intervention)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalIntervention = angular.copy(@$scope.selectedIntervention)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  hideForm: ->
    if !@$scope.originalIntervention?
      if !angular.equals(@$scope.originalIntervention, @$scope.selectedIntervention)
        @$scope.selectedIntervention = angular.copy(@$scope.originalIntervention)
    @$scope.errors = []
