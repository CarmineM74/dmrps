class @UsersCtrl
  @inject: ['$scope','$log','dialogsSvc','usersSvc','sessionSvc']
  constructor: (@$scope, @$log,@dialogsSvc, @usersSvc,@sessionSvc) ->

    @$scope.$on('UsersSvc:Index:Failure',@indexFailed)
    @$scope.$on('UsersSvc:Index:Success',@indexSuccess)
    @$scope.$on('UsersSvc:Save:Success',@saveSuccess)
    @$scope.$on('UsersSvc:Save:Failure',@reqFailed)
    @$scope.$on('UsersSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('UsersSvc:Destroy:Failure', @deleteFailed)

    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectUser = angular.bind(this, @selectUser)
    @$scope.newUser = angular.bind(this, @newUser)
    @$scope.saveUser = angular.bind(this, @saveUser)
    @$scope.deleteUser = angular.bind(this, @deleteUser)
    @$scope.hideForm = angular.bind(this, @hideForm)
    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.pageChanged = angular.bind(this, @pageChanged)

    @$scope.$on('SessionSvc:CurrentUser:Authenticated', @authenticated)
    @sessionSvc.authenticated_user()

    @$scope.errors = []

    @$scope.selectedUser = {}
    @$scope.originalUser = undefined
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''
    @$scope.showForm = false
    @$scope.availableRoles = [ {codice: 'admin', descrizione: 'Amministratore'},{codice: 'user', descrizione: 'Utente'}]

  authenticated: =>
    unless @$scope.can('ManageUsers',{fail_and_logout: true})
      return
    @initPagination()
    @index()

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    @$log.log('[User] Original: ' + JSON.stringify(@$scope.originalUser))
    @$log.log('[User] Selected: ' + JSON.stringify(@$scope.selectedUser))
    if angular.equals(@$scope.originalUser,@$scope.selectedUser)
      false
    else
      true

  initPagination: ->
    @$scope.users = []
    @$scope.allUsers = []
    @$scope.itemsPerPage = 10
    @$scope.nrOfPages = 0
    @$scope.currentPage = 1

  index: ->
    @usersSvc.index()

  indexSuccess: (events, users) =>
    @$scope.allUsers = users
    @$scope.nrOfPages = Math.floor(users.length / 10)
    if (users.length % 10 ) != 0
      @$scope.nrOfPages += 1
    @pageChanged(1)

  indexFailed: (response) =>
    @$log.log('Error while retrieving Users#index')
    @dialogsSvc.alert("Impossibile recuperare l'elenco degli utenti!")

  pageChanged: (page) ->
    @$scope.currentPage = page
    start = (@$scope.currentPage - 1) * @$scope.itemsPerPage
    stop = start + (@$scope.itemsPerPage - 1)
    if stop > @$scope.allUsers.length
      stop = @$scope.allUsers.length - 1
    @$scope.users = @$scope.allUsers[start..stop]

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
    @$scope.selectedUser = {email: '', password: '', password_confirmation: '', name: '', role: '', notifications_email: '', ftp_home: '', codice_cliente: '', tracciato_feedback_ricevimento_merce: '', tracciato_richiesta_evasione_merce: '', tracciato_feedback_spedizione_merce: '', email_responsabili_movimentazione: ''}
    @$scope.formCaption = 'Nuovo utente'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveUser: (user) ->
    @usersSvc.save(user)

  saveSuccess: (event, args) =>
    @$scope.errors = []
    @$scope.originalUser = angular.copy(@$selectedUser)
    @hideForm()
    @dialogsSvc.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    @dialogsSvc.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  deleteUser: (user) ->
    @dialogsSvc.messageBox("Cancellazione utente", "Proseguo con la cancellazione dell'utente?", @dialogsSvc.SiNoButtons,
      (result) =>
        if result == 'si'
          @usersSvc.destroy(user)
          @hideForm()
    )

  deleteSuccess: =>
    @$scope.errors = []
    @$scope.originalUser = undefined
    @$scope.selectedUser = undefined
    @dialogsSvc.alert('Utente rimosso con successo!')
    @hideForm()

  deleteFailed: (evt,args) =>
    @$scope.errors = []
    @dialogsSvc.alert("Impossibile eliminare l'utente selezionato:<br/>" + args.data.error_msg)

  hideForm: ->
    if !@$scope.originalUser?
      if !angular.equals(@$scope.originalUser,@$scope.selectedUser)
        @$scope.selectedUser = angular.copy(@$scope.originalUser)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
