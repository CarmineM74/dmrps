class @EditLocationCtrl
  @inject: ['$scope','$log','$routeParams','dialogsSvc','dmLocationsvc','dmClientsSvc','$location']
  constructor: (@$scope, @$log, @$routeParams, @dialogsSvc, @dmLocationsSvc,@dmClientsSvc,@$location) ->
    @$scope.errors = []
    @$scope.originalLocation = undefined

    @$scope.$on('dmClientsSvc:Get:Failure',@clientDetailsFailed)
    @$scope.$on('dmLocationsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmLocationsSvc:Save:Failure',@reqFailed)
    @$scope.$on('dmLocationsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmLocationsSvc:Destroy:Failure', @reqFailed)
    @$scope.$on('dmLocationsSvc:Get:Success',@locationRetrieved)
    @$scope.$on('dmLocationsSvc:Get:Failure',@locationRetrieveFailed)

    @$scope.saveLocation = angular.bind(this, @saveLocation)
    @$scope.quitEditing = angular.bind(this, @quitEditing)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.editMode = @$routeParams.location_id?
    @$scope.client = @dmClientsSvc.get(@$routeParams.client_id)

    if @$scope.editMode
      @$scope.formCaption = 'Modifica sede'
      @$scope.formSubmitCaption = 'Aggiorna'
      @$scope.location = @dmLocationsSvc.get(@$routeParams.location_id)
    else
      @$scope.formCaption = 'Nuova sede'
      @$scope.formSubmitCaption = 'Crea'
      @$scope.location = {}
      @$scope.originalLocation = undefined

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    #@$log.log('Original: ' + JSON.stringify(@$scope.originalLocation))
    #@$log.log('Selected: ' + JSON.stringify(@$scope.location))
    if angular.equals(@$scope.originalLocation,@$scope.location)
      false
    else
      true

  quitEditing: ->
    @$location.path('/clients/edit/' + @$scope.client.id)

  saveLocation: (location) ->
    @dmLocationsSvc.save(location,@$scope.client.id)

  saveSuccess: (event, args) =>
    @$scope.errors = []
    @$scope.originalLocation = angular.copy(@$scope.location)
    @hideForm()
    @dialogsSvc.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    @dialogsSvc.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  locationRetrieveFailed: (event, args) =>
    @$log.log('[LocationRetrieveFailed]: ' + JSON.stringify(args))
    @dialogsSvc.alert('Impossibile recuperare i dettagli della sede')

  locationRetrieved: (event, args) =>
    @$log.log('Location: ' + JSON.stringify(args))
    @$scope.originalLocation = angular.copy(@$scope.location)

  hideForm: ->
    if !@$scope.originalLocation?
      if !angular.equals(@$scope.originalLocation, @$scope.location)
        @$scope.location = angular.copy(@$scope.originalLocation)
    @$scope.errors = []
