class @ClientsCtrl
  @inject: ['$scope','$log','dmClientsSvc']
  constructor: (@$scope, @$log, @dmClientsSvc) ->
    @$scope.clients = []
    @$scope.selectedClient = {}
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.$on('dmClientsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectClient = angular.bind(this, @selectClient)
    @$scope.newClient = angular.bind(this, @newClient)
    @$scope.$on('dmClientsSvc:Save:Success',@reqSuccess)
    @$scope.$on('dmClientsSvc:Save:Failure',@reqFailed)
    @$scope.saveClient = angular.bind(this, @saveClient)
    @$scope.$on('dmClientsSvc:Destroy:Success', @reqSuccess)
    @$scope.$on('dmClientsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteClient = angular.bind(this, @deleteClient)
    @$scope.hideForm = angular.bind(this, @hideForm)

  clearValidationErrors: ->
    angular.element('.control-group')
      .removeClass('error')
      .find('span.help-block')
      .remove()

  showValidationErrors: (errors) ->
    #@$log.log(JSON.stringify(errors))
    errors = errors.data
    error_msg = if errors.error_msg? then errors.error_msg else 'Operazione fallita!'
    bootbox.alert(error_msg, =>
      for k,v of errors.errors
        angular.element('.control-group.'+k)
          .addClass('error')
          .find('input')
          .after("<span class='help-block'>"+v+"</span>")
    )

  index: ->
    @$scope.clients = @dmClientsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Clients#index')
    bootbox.alert("Impossibile recuperare l'elenco dei clienti!")

  selectClient: (client) ->
    @$scope.selectedClient = client
    @$scope.formCaption = 'Modifica cliente'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newClient: ->
    @$scope.selectedClient = {}
    @$scope.formCaption = 'Nuovo cliente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveClient: (client) ->
    @dmClientsSvc.save(client)

  reqSuccess: =>
    @clearValidationErrors()
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @clearValidationErrors()
    @showValidationErrors(args)

  deleteClient: (client) ->
    bootbox.confirm("Proseguo con la cancellazione del cliente?",(result) =>
      if result
        @dmClientsSvc.destroy(client)
        @hideForm()
    )

  hideForm: ->
    @$scope.showForm = false
    @clearValidationErrors()
    @index()
