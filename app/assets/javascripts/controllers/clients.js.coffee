class @ClientsCtrl
  @inject: ['$scope','$log','$location', 'dmClientsSvc']
  constructor: (@$scope, @$log, @$location,  @dmClientsSvc) ->
    @$scope.clients = []
    @$scope.query = ''

    @$scope.$on('dmClientsSvc:Index:Failure',@indexFailed)
    @$scope.$on('dmClientsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmClientsSvc:Destroy:Failure', @deleteFailed)

    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.filter = angular.bind(this, @filter)
    @$scope.newClient = angular.bind(this, @newClient)
    @$scope.editClient = angular.bind(this, @editClient)
    @$scope.deleteClient = angular.bind(this, @deleteClient)

    @index()

  index: ->
    @$scope.clients = @dmClientsSvc.index('')

  filter: ->
    @$scope.clients = @dmClientsSvc.index(@$scope.query)

  indexFailed: (response) =>
    @$log.log('Error while retrieving Clients#index')
    bootbox.alert("Impossibile recuperare l'elenco dei clienti!")

  reqFailed: (event, args) =>
    bootbox.alert("Operazione fallita!")

  newClient: ->
    @$location.path('clients/add')

  editClient: (client) ->
    @$location.path('clients/edit/'+client.id)

  deleteClient: (client) ->
    bootbox.confirm("Proseguo con la cancellazione del cliente?",(result) =>
      if result
        @dmClientsSvc.destroy(client)
    )
  
  deleteSuccess: =>
    bootbox.alert('Cliente rimosso con successo!')

  deleteFailed: (evt, args) =>
    bootbox.alert("Impossibile eliminare il cliente:<br/>" + args.data.error_msg)

