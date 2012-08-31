class @UsersCtrl
  @inject: ['$scope','$log','dmUsersSvc']
  constructor: (@$scope, @$log, @dmUsersSvc) ->
    @$scope.users = []
    @$scope.selectedUser = {}
    @$scope.formCaption = ''
    @$scope.formSubmitCaption = ''

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

  index: ->
    @$scope.users = @dmUsersSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Users#index')
    alert('Cannot retrieve users index!')

  selectUser: (user) ->
    @$scope.selectedUser = user
    @$scope.formCaption = 'Modifica utente'
    @$scope.formSubmitCaption = 'Aggiorna dati'

  newUser: ->
    @$scope.selectedUser = {}
    @$scope.formCaption = 'Nuovo utente'
    @$scope.formSubmitCaption = 'Salva'

  saveUser: (user) ->
    @dmUsersSvc.save(user)

  reqSuccess: =>
    alert('Operazione completata!')
    @index()

  reqFailed: (response) =>
    alert(response)
