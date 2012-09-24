class @ClientsCtrl
  @inject: ['$scope','$log','dmClientsSvc']
  constructor: (@$scope, @$log, @dmClientsSvc) ->
    @$scope.errors = []
    @$scope.clients = []
    @$scope.selectedClient = {}
    @$scope.originalClient = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.tipi_contratto = [
        {name: 'Orario', value: 'Orario'},
        {name: 'Prestazione', value: 'Prestazione'}
    ]

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
    unless @$scope.originalClient?
        return false
    @$log.log('Original: ' + JSON.stringify(@$scope.originalClient))
    @$log.log('Selected: ' + JSON.stringify(@$scope.selectedClient))
    if angular.equals(@$scope.originalClient,@$scope.selectedClient)
      @$log.log('NOT DIRTY')
      false
    else
      @$log.log('IS DIRTY')
      true

  index: ->
    @$scope.selectedClient = {}
    @$scope.originalClient = undefined
    @$scope.clients = @dmClientsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Clients#index')
    bootbox.alert("Impossibile recuperare l'elenco dei clienti!")

  selectClient: (client) ->
    @$scope.originalClient = angular.copy(client)
    @$scope.selectedClient = client
    @$scope.formCaption = 'Modifica cliente'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newClient: ->
    @$scope.originalClient = undefined
    @$scope.selectedClient = {}
    @$scope.formCaption = 'Nuovo cliente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveClient: (client) ->
    @dmClientsSvc.save(client)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalClient = angular.copy(@$scope.selectedClient)
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
    @$scope.originalClient = undefined
    @$scope.selectedClient = undefined
    bootbox.alert('Cliente rimosso con successo!')
    @hideform()

  hideForm: ->
    if !@$scope.originalClient?
      if !angular.equals(@$scope.originalClient, @$scope.selectedClient)
        @$scope.selectedClient = angular.copy(@$scope.originalClient)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
