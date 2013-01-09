class @LocationsCtrl
  @inject: ['$scope','$log','$routeParams','dmLocationsvc','dmClientsSvc','$location']
  constructor: (@$scope, @$log, @$routeParams, @dmLocationsSvc,@dmClientsSvc,@$location) ->
    @$scope.errors = []
    @$scope.locations = []
    @$scope.selectedLocation = {}
    @$scope.originalLocation = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.$on('dmLocationsSvc:Index:Success',@locationsRetrieved)
    @$scope.$on('dmLocationsSvc:Index:Failure',@indexFailed)
    @$scioe.$on('dmClientsSvc:Get:Failure',@clientDetailsFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectLocation = angular.bind(this, @selectLocation)
    @$scope.newLocation = angular.bind(this, @newLocation)
    @$scope.$on('dmLocationsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmLocationsSvc:Save:Failure',@reqFailed)
    @$scope.saveLocation = angular.bind(this, @saveLocation)
    @$scope.$on('dmLocationsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmLocationsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteLocation = angular.bind(this, @deleteLocation)
    @$scope.hideForm = angular.bind(this, @hideForm)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @index()

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    #@$log.log('Original: ' + JSON.stringify(@$scope.originalLocation))
    #@$log.log('Selected: ' + JSON.stringify(@$scope.selectedLocation))
    if angular.equals(@$scope.originalLocation,@$scope.selectedLocation)
      false
    else
      true

  index: ->
    @$scope.locations = @dmLocationsSvc.index(@$routeParams.client_id)

  locationsRetrieved: (response) =>
    @$scope.client = @dmClientsSvc.get(@$routeParams.client_id)

  indexFailed: (response) =>
    @$log.log('Error while retrieving Locations#index')
    bootbox.alert("Impossibile recuperare l'elenco delle sedi per il cliente!")
    @$location.path('clients')

  clientDetailsFailed: (response) =>
    @$log.log('Error while retrieving Clients#show')
    bootbox.alert("Errore durante il recupero dei dettagli del Cliente!")
    @$location.path('clients')

  selectLocation: (location) ->
    @$scope.originalLocation = angular.copy(location)
    @$scope.selectedLocation = location
    @$scope.formCaption = 'Modifica sede'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newLocation: ->
    @$scope.originalLocation = undefined
    @$scope.selectedLocation = {}
    @$scope.formCaption = 'Nuova sede'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveLocation: (location) ->
    @dmLocationsSvc.save(location,@$routeParams.client_id)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalLocation = angular.copy(@$scope.selectedLocation)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  deleteLocation: (location) ->
    bootbox.confirm("Proseguo con la cancellazione della sede?",(result) =>
      if result
        @dmLocationsSvc.destroy(location)
        @hideForm()
    )
  
  deleteSuccess: =>
    @$scope.errors = []
    @$scope.originalLocation = undefined
    @$scope.selectedLocation = undefined
    bootbox.alert('Sede rimossa con successo!')
    @hideform()

  hideForm: ->
    if !@$scope.originalLocation?
      if !angular.equals(@$scope.originalLocation, @$scope.selectedLocation)
        @$scope.selectedLocation = angular.copy(@$scope.originalLocation)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
