class @LocationsCtrl
  @inject: ['$scope','$log','dmClientsSvc']
  constructor: (@$scope, @$log, @dmClientsSvc) ->
    @$scope.errors = []
    @$scope.locations = []
    @$scope.selectedLocation = {}
    @$scope.originalLocation = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.$on('dmClientsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectClient = angular.bind(this, @selectClient)
    @$scope.newClient = angular.bind(this, @newClient)
    @$scope.$on('dmClientsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmClientsSvc:Save:Failure',@reqFailed)
    @$scope.saveClient = angular.bind(this, @saveClient)
    @$scope.$on('dmClientsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmClientsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteClient = angular.bind(this, @deleteClient)
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
    @$scope.clients = @dmClientsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Clients#index')
    bootbox.alert("Impossibile recuperare l'elenco delle sedi per il cliente!")

  selectClient: (client) ->
    @$scope.originalLocation = angular.copy(client)
    @$scope.selectedLocation = client
    @$scope.formCaption = 'Modifica cliente'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newClient: ->
    @$scope.originalLocation = undefined
    @$scope.selectedLocation = {}
    @$scope.formCaption = 'Nuovo cliente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveClient: (client) ->
    @dmClientsSvc.save(client)

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

  deleteClient: (client) ->
    bootbox.confirm("Proseguo con la cancellazione del cliente?",(result) =>
      if result
        @dmClientsSvc.destroy(client)
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
    @index()
