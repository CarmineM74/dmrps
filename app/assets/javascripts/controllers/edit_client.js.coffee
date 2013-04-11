class @EditClientCtrl
  @inject: ['$scope','$log','$location','$routeParams','dmClientsSvc','dmLocationsSvc','dmContactsSvc']
  constructor: (@$scope, @$log, @$location, @$routeParams, @dmClientsSvc, @dmLocationsSvc, @dmContactsSvc) ->
    @$scope.errors = []
    @$scope.locations = []
    @$scope.contacts = []
    @$scope.originalClient = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.query = ''

    @$scope.tipi_contratto = [
        {name: 'Orario', value: 'Orario'},
        {name: 'Prestazione', value: 'Prestazione'}
    ]

    @$scope.$on('dmClientsSvc:Get:Success',@clientRetrieveSuccess)
    @$scope.$on('dmClientsSvc:Get:Failure',@clientRetrieveFailed)
    @$scope.$on('dmClientsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmClientsSvc:Save:Failure',@reqFailed)
    @$scope.$on('dmLocationsSvc:Index:Failure',@locationsRetrieveFailed)
    @$scope.$on('dmLocationsSvc:Destroy:Success',@locationDeleted)
    @$scope.$on('dmLocationsSvc:Destroy:Failure',@locationDeleteFailed)
    @$scope.$on('dmContactsSvc:Index:Failure', @contactsRetrieveFailed)
    @$scope.$on('dmContactsSvc:Save:Success', @contactsSaveSuccess)
    @$scope.$on('dmContactsSvc:Save:Failure', @contactsSaveFailed)
    @$scope.$on('dmContactsSvc:Destroy:Success', @contactsSaveSuccess)
    @$scope.$on('dmContactsSvc:Destroy:Failure', @contactsDestroyFailure)

    @$scope.newClient = angular.bind(this, @newClient)
    @$scope.saveClient = angular.bind(this, @saveClient)
    @$scope.quitEditing = angular.bind(this, @quitEditing)

    @$scope.newLocation = angular.bind(this, @newLocation)
    @$scope.editLocation = angular.bind(this, @editLocation)
    @$scope.deleteLocation = angular.bind(this, @deleteLocation)

    @$scope.saveContact = angular.bind(this, @saveContact)
    @$scope.deleteContact = angular.bind(this, @deleteContact)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.editMode = @$routeParams.client_id?

    if @$scope.editMode
      @$scope.formCaption = 'Modifica cliente'
      @$scope.formSubmitCaption = 'Aggiorna'
      @$scope.client = @dmClientsSvc.get(@$routeParams.client_id)
    else
      @$scope.formCaption = 'Nuovo cliente'
      @$scope.formSubmitCaption = 'Crea'
      @$scope.client = {}
      @$scope.originalClient = undefined

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    unless @$scope.originalClient?
        return true
    @$log.log('Original: ' + JSON.stringify(@$scope.originalClient))
    @$log.log('Selected: ' + JSON.stringify(@$scope.selectedClient))
    if angular.equals(@$scope.originalClient,@$scope.selectedClient)
      false
    else
      true

  saveContact: (contact) ->
    @dmContactsSvc.save(@$scope.client.id,contact)

  deleteContact: (contact) ->
    bootbox.confirm("Proseguo con la cancellazione del contatto?", (result) =>
      if result
        @dmContactsSvc.destroy(contact)
    )

  contactsSaveSuccess: (evt, args) =>
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  contactSaveFailure: (evt, args) =>
    @$scope.validationErrors = args.data

  contactDestroySuccess: (evt, args) =>
    bootbox.alert("Contatto eliminato con successo!")
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  contactDestroyFailure: (evt, args) =>
    @$log.log("[contactDestroyFailure] ERROR: " + JSON.stringify(args))
    bootbox.alert("Si e' verificato un errore durante la rimozione del contatto!")

  newLocation: ->
    @$location.path('/locations/add/' + @$scope.client.id)

  editLocation: (location) ->
    @$location.path('/locations/edit/' + @$scope.client.id + '/' + location.id)

  deleteLocation: (location) ->
    bootbox.confirm("Proseguo con la cancellazione della sede?", (result) =>
      if result
        @dmLocationsSvc.destroy(location)
    )

  locationDeleted: =>
    @$scope.locations = @dmLocationsSvc.index(@$scope.client.id)

  locationDeleteFailure: (event, args) =>
    @$log.log("[LocationDeleteFailure] " + JSON.stringify(args))
    bootbox.alert("Operazione fallita!")

  clientRetrieveSuccess: (evt, response) =>
    @$scope.originalClient = angular.copy(@$scope.client)
    @$scope.locations = @dmLocationsSvc.index(@$scope.client.id)
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  clientRetrieveFailed: (ievt, response) =>
    @$log.log('Error while retrieving Client')
    @$scope.client = {}
    @$scope.originalClient = undefined
    bootbox.alert("Impossibile recuperare i dati per il cliente")

  locationsRetrieveFailed: (evt, response) =>
    @$log.log('Errore durante il recupero delle sedi per il cliente')
    bootbox.alert("Impossibile recuperare l'elenco delle sedi per il cliente")

  contactsRetrieveFailed: (evt, response) =>
    @$log.log('Errore durante il recupero dei contatti per il cliente')
    bootbox.alert("Impossibile recuperare i contatti per il cliente")

  saveClient: (client) ->
    @dmClientsSvc.save(client)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalClient = angular.copy(@$scope.client)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  quitEditing: ->
    @$location.path('/clients')

  hideForm: ->
    if !@$scope.originalClient?
      if !angular.equals(@$scope.originalClient, @$scope.client)
        @$scope.client = angular.copy(@$scope.originalClient)
    @$scope.showForm = false
    @$scope.errors = []
