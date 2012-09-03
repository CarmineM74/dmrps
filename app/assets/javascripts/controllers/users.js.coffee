class @UsersCtrl
  @inject: ['$scope','$log','dmUsersSvc']
  constructor: (@$scope, @$log, @dmUsersSvc) ->
    @$scope.users = []
    @$scope.selectedUser = {}
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.$on('dmUsersSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectUser = angular.bind(this, @selectUser)
    @$scope.newUser = angular.bind(this, @newUser)
    @$scope.$on('dmUsersSvc:Save:Success',@reqSuccess)
    @$scope.$on('dmUsersSvc:Save:Failure',@reqFailed)
    @$scope.saveUser = angular.bind(this, @saveUser)
    @$scope.$on('dmUsersSvc:Destroy:Success', @reqSuccess)
    @$scope.$on('dmUsersSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteUser = angular.bind(this, @deleteUser)
    @$scope.hideForm = angular.bind(this, @hideForm)

  clearValidationErrors: ->
    angular.element('.control-group')
      .removeClass('error')
      .find('span.help-block')
      .remove()

  showValidationErrors: (errors) ->
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
    @$scope.users = @dmUsersSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Users#index')
    bootbox.alert("Impossibile recuperare l'elenco degli utenti!")

  selectUser: (user) ->
    @$scope.selectedUser = user
    @$scope.selectedUser.password = ''
    @$scope.selectedUser.password_confirmation = ''
    @$scope.formCaption = 'Modifica utente'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newUser: ->
    @$scope.selectedUser = {email: '', password: '', password_confirmation: ''}
    @$scope.formCaption = 'Nuovo utente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveUser: (user) ->
    @dmUsersSvc.save(user)

  reqSuccess: =>
    @clearValidationErrors()
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @clearValidationErrors()
    @showValidationErrors(args)

  deleteUser: (user) ->
    bootbox.confirm("Proseguo con la cancellazione dell'utente?",(result) =>
      if result
        @dmUsersSvc.destroy(user)
        @hideForm()
    )

  hideForm: ->
    @$scope.showForm = false
    @clearValidationErrors()
    @index()
