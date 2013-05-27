class @ClientsCtrl
  @inject: ['$scope','$log','$location','dialogsSvc', 'dmClientsSvc']
  constructor: (@$scope, @$log, @$location,@dialogsSvc,  @dmClientsSvc) ->
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
    @dialogsSvc.alert("Impossibile recuperare l'elenco dei clienti!")

  reqFailed: (event, args) =>
    @dialogsSvc.alert("Operazione fallita!")

  newClient: ->
    @$location.path('clients/add')

  editClient: (client) ->
    @$location.path('clients/edit/'+client.id)

  deleteClient: (client) ->
    @dialogsSvc.messageBox("Cancellazione cliente","Proseguo con la cancellazione del cliente?",@dialogsSvc.SiNoButtons,
      (result) =>
        if result == 'si'
          @dmClientsSvc.destroy(client)
    )
  
  deleteSuccess: =>
    @dialogsSvc.alert('Cliente rimosso con successo!')

  deleteFailed: (evt, args) =>
    @dialogsSvc.alert("Impossibile eliminare il cliente:<br/>" + args.data.error_msg)

