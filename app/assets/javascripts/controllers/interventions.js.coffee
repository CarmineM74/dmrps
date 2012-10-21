class @InterventionsCtrl
  @inject: ['$scope','$log','dmInterventionsSvc','dmClientsSvc','dmLocationsSvc','$routeParams']
  constructor: (@$scope, @$log, @dmInterventionsSvc,@dmClientsSvc,@dmLocationsSvc,@$routeParams) ->
    @$scope.errors = []
    @$scope.interventions = []
    @$scope.clients = []
    @$scope.selectedClient = undefined
    @$scope.locations = []
    @$scope.selectedLocation = undefined
    @$scope.selectedIntervention = {}
    @$scope.originalIntervention = undefined

    @$scope.$on('dmClientsSvc:Index:Failure',@clientsRetrievalFailed)
    @$scope.$on('dmLocationsSvc:Index:Failure',@locationsRetrievalFailed)

    @$scope.$on('dmInterventionsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectIntervention = angular.bind(this, @selectIntervention)
    @$scope.newIntervention = angular.bind(this, @newIntervention)
    @$scope.$on('dmInterventionsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmInterventionsSvc:Save:Failure',@reqFailed)
    @$scope.saveIntervention = angular.bind(this, @saveIntervention)
    @$scope.$on('dmInterventionsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmInterventionsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteIntervention = angular.bind(this, @deleteIntervention)
    @$scope.hideForm = angular.bind(this, @hideForm)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.clientChanged = angular.bind(this, @clientChanged)
    @$scope.locationChanged = angular.bind(this, @locationChanged)

    @index()

  clientsRetrievalFailed: (response) ->
    @$log.log('Error retrieving clients list')
    bootbox.alert("Si e' verificato un errore durante il recupero dell'elenco clienti!")

  locationsRetrievalFailed: (response) ->
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

  index: ->
    @$scope.selectedIntervention = {}
    @$scope.originalIntervention = undefined
    @$scope.interventions = @dmInterventionsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Interventions#index')
    bootbox.alert("Impossibile recuperare l'elenco degli interventi!")

  selectIntervention: (intervention) ->
    @$scope.originalIntervention = angular.copy(intervention)
    @$scope.selectedIntervention = intervention
    @$scope.formCaption = 'Modifica intervento'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newIntervention: ->
    @$scope.clients = @dmClientsSvc.index()
    @$scope.originalIntervention = undefined
    @$scope.selectedIntervention = {}
    @$scope.formCaption = 'Nuovo intervento'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

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

  deleteIntervention: (intervention) ->
    bootbox.confirm("Proseguo con la cancellazione del intervento?",(result) =>
      if result
        @dmInterventionsSvc.destroy(intervention)
        @hideForm()
    )
  
  deleteSuccess: =>
    @$scope.errors = []
    @$scope.originalIntervention = undefined
    @$scope.selectedIntervention = undefined
    bootbox.alert('Interventione rimosso con successo!')
    @hideform()

  hideForm: ->
    if !@$scope.originalIntervention?
      if !angular.equals(@$scope.originalIntervention, @$scope.selectedIntervention)
        @$scope.selectedIntervention = angular.copy(@$scope.originalIntervention)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
