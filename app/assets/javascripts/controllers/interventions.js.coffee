class @InterventionsCtrl
  @inject: ['$scope','$log','dmInterventionsSvc']
  constructor: (@$scope, @$log, @dmInterventionsSvc) ->
    @$scope.errors = []
    @$scope.interventions = []
    @$scope.selectedIntervention = {}
    @$scope.originalIntervention = undefined

    @$scope.$on('dmInterventionsSvc:Index:Failure',@indexFailed)
    @$scope.fetchAll = angular.bind(this, @index)
    @$scope.selectIntervention = angular.bind(this, @selectIntervention)
    @$scope.newIntervention = angular.bind(this, @newIntervention)
    @$scope.$on('dmInterventionsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmInterventionsSvc:Save:Failure',@reqFailed)
    @$scope.saveIntervention = angular.bind(this, @saveIntervention)
    @$scope.$on('dmInterventionsSvc:Destroy:Success', @deleteSuccess)
    @$scope.$on('dmInterventionsSvc:Destroy:Failure', @reqFailed)
    @$scope.deleteIntervention = angular.bind(this, @deleteIntervention)
    @$scope.hideForm = angular.bind(this, @hideForm)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @index()

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    unless @$scope.originalIntervention?
        return true
    @$log.log('Original: ' + JSON.stringify(@$scope.originalIntervention))
    @$log.log('Selected: ' + JSON.stringify(@$scope.selectedIntervention))
    if angular.equals(@$scope.originalIntervention,@$scope.selectedIntervention)
      false
    else
      true

  index: ->
    @$scope.selectedIntervention = {}
    @$scope.originalIntervention = undefined
    @$scope.interventions = @dmInterventionsSvc.index()

  indexFailed: (response) =>
    @$log.log('Error while retrieving Interventions#index')
    bootbox.alert("Impossibile recuperare l'elenco degli interventi!")

  selectIntervention: (intervention) ->
    @$scope.originalIntervention = angular.copy(intervention)
    @$scope.selectedIntervention = intervention
    @$scope.formCaption = 'Modifica intervento'
    @$scope.formSubmitCaption = 'Aggiorna dati'
    @$scope.showForm = true

  newIntervention: ->
    @$scope.originalIntervention = undefined
    @$scope.selectedIntervention = {}
    @$scope.formCaption = 'Nuovo intervento'
    @$scope.formSubmitCaption = 'Salva'
    @$scope.showForm = true

  saveIntervention: (intervention) ->
    @dmInterventionsSvc.save(intervention)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalIntervention = angular.copy(@$scope.selectedIntervention)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  deleteIntervention: (intervention) ->
    bootbox.confirm("Proseguo con la cancellazione del intervento?",(result) =>
      if result
        @dmInterventionsSvc.destroy(intervention)
        @hideForm()
    )
  
  deleteSuccess: =>
    @$scope.errors = []
    @$scope.originalIntervention = undefined
    @$scope.selectedIntervention = undefined
    bootbox.alert('Interventione rimosso con successo!')
    @hideform()

  hideForm: ->
    if !@$scope.originalIntervention?
      if !angular.equals(@$scope.originalIntervention, @$scope.selectedIntervention)
        @$scope.selectedIntervention = angular.copy(@$scope.originalIntervention)
    @$scope.showForm = false
    @$scope.errors = []
    @index()
