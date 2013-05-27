class @EditClientCtrl
  @inject: ['$scope','$log','$location','$routeParams','dialogsSvc','dmClientsSvc','dmLocationsSvc','dmContactsSvc']
  constructor: (@$scope, @$log, @$location, @$routeParams, @dialogsSvc,@dmClientsSvc, @dmLocationsSvc, @dmContactsSvc) ->
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
    @$scope.$on('dmContactsSvc:Destroy:Success', @contactsDestroySuccess)
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
      @dmClientsSvc.get(@$routeParams.client_id)
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
    @$log.log('Selected: ' + JSON.stringify(@$scope.client))
    if angular.equals(@$scope.originalClient,@$scope.client)
      false
    else
      true

  saveContact: (contact) ->
    @dmContactsSvc.save(@$scope.client.id,contact)

  deleteContact: (contact) ->
    @dialogsSvc.messageBox("Cancellazione contatto","Proseguo con la cancellazione del contatto?", @dialogsSvc.SiNoButtons,
      (result) =>
        if result == 'si'
          @dmContactsSvc.destroy(contact)
    )

  contactsSaveSuccess: (evt, args) =>
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  contactSaveFailure: (evt, args) =>
    @$scope.validationErrors = args.data

  contactsDestroySuccess: (evt, args) =>
    @dialogsSvc.alert("Contatto eliminato con successo!")
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  contactsDestroyFailure: (evt, args) =>
    @$log.log("[contactDestroyFailure] ERROR: " + JSON.stringify(args))
    @dialogsSvc.alert("Si e' verificato un errore durante la rimozione del contatto:<br/>" + args.data.error_msg)

  newLocation: ->
    @$location.path('/locations/add/' + @$scope.client.id)

  editLocation: (location) ->
    @$location.path('/locations/edit/' + @$scope.client.id + '/' + location.id)

  deleteLocation: (location) ->
    @dialogsSvc.messageBox("Cancellazione sede", "Proseguo con la cancellazione della sede?", @dialogsSvc.SiNoButtons,
      (result) =>
        if result == 'si'
          @dmLocationsSvc.destroy(location,@$scope.client)
    )

  locationDeleted: (evt, args) =>
    @$log.log('[locationDeleted]: ' + JSON.stringify(@$scope.client))
    @$scope.locations = @dmLocationsSvc.index(@$scope.client.id)

  locationDeleteFailed: (event, args) =>
    @$log.log("[LocationDeleteFailed] " + JSON.stringify(args))
    @dialogsSvc.alert("Impossibile eliminare la sede:<br/>"+args.data.error_msg)

  clientRetrieveSuccess: (evt, response) =>
    @$scope.client = response
    @$scope.originalClient = angular.copy(@$scope.client)
    @$scope.locations = @dmLocationsSvc.index(@$scope.client.id)
    @$scope.contacts = @dmContactsSvc.index(@$scope.client.id)

  clientRetrieveFailed: (ievt, response) =>
    @$log.log('Error while retrieving Client')
    @$scope.client = {}
    @$scope.originalClient = undefined
    @dialogsSvc.alert("Impossibile recuperare i dati per il cliente")

  locationsRetrieveFailed: (evt, response) =>
    @$log.log('Errore durante il recupero delle sedi per il cliente')
    @dialogsSvc.alert("Impossibile recuperare l'elenco delle sedi per il cliente")

  contactsRetrieveFailed: (evt, response) =>
    @$log.log('Errore durante il recupero dei contatti per il cliente')
    @dialogsSvc.alert("Impossibile recuperare i contatti per il cliente")

  saveClient: (client) ->
    @dmClientsSvc.save(client)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalClient = angular.copy(@$scope.client)
    @hideForm()
    @dialogsSvc.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    @dialogsSvc.alert('Operazione completata!')
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
