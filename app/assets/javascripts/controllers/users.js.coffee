class @UsersCtrl
  @inject: ['$scope','$log','dmUsersSvc']
  constructor: (@$scope, @$log, @dmUsersSvc) ->
    @$scope.errors = []
    @$scope.users = []
    @$scope.selectedUser = {}
    @$scope.originalUser = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false

    @$scope.$on('dmUsersSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectUser = angular.bind(this, @selectUser)
    @$scope.newUser = angular.bind(this, @newUser)
    @$scope.$on('dmUsersSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmUsersSvc:Save:Failure',@reqFailed)
    @$scope.saveUser = angular.bind(this, @saveUser)
    @$scope.$on('dmUsersSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmUsersSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteUser = angular.bind(this, @deleteUser)
    @$scope.hideForm = angular.bind(this, @hideForm)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @index()

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    #@$log.log('Original: ' + JSON.stringify(@$scope.originalUser))
    #@$log.log('Selected: ' + JSON.stringify(@$scope.selectedUser))
    if angular.equals(@$scope.originalUser,@$scope.selectedUser)
      false
    else
      true

  index: ->
    @$scope.users = @dmUsersSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Users#index')
    bootbox.alert("Impossibile recuperare l'elenco degli utenti!")

  selectUser: (user) ->
    @$scope.selectedUser = user
    @$scope.selectedUser.password = ''
    @$scope.selectedUser.password_confirmation = ''
    @$scope.originalUser = angular.copy(user)
    @$scope.formCaption = 'Modifica utente'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newUser: ->
    @$scope.originalUser = undefined
    @$scope.selectedUser = {email: '', password: '', password_confirmation: ''}
    @$scope.formCaption = 'Nuovo utente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveUser: (user) ->
    @dmUsersSvc.save(user)

  saveSuccess: (event, args) =>
    @$scope.errors = []
    @$scope.originalUser = angular.copy(@$selectedUser)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  deleteUser: (user) ->
    bootbox.confirm("Proseguo con la cancellazione dell'utente?",(result) =>
      if result
        @dmUsersSvc.destroy(user)
        @hideForm()
    )
  
  deleteSuccess: =>
    @$scope.errors = []
    @$scope.originalUser = undefined
    @$scope.selectedUser = undefined
    bootbox.alert('Utente rimosso con successo!')
    @hideForm()

  hideForm: ->
    if !@$scope.originalUser?
      if !angular.equals(@$scope.originalUser,@$scope.selectedUser)
        @$scope.selectedUser = angular.copy(@$scope.originalUser)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
