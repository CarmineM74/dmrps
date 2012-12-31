class @EditInterventionCtrl
  @inject: ['$scope','$log','dmInterventionsSvc','dmClientsSvc','dmLocationsSvc','$routeParams','$location']
  constructor: (@$scope, @$log, @dmInterventionsSvc,@dmClientsSvc,@dmLocationsSvc,@$routeParams,@$location) ->
    @$scope.errors = []
    @$scope.dateTimePickerOpts = {
        changeYear: true
        changeMonth: true
        dateFormat: 'dd/mm/yy'
        timeFormat: 'hh:mm'
        hourGrid: 4
        minuteGrid: 10
        timeText: 'Orario'
        hourText: 'HH'
        minuteText: 'MM'
    }

    @$scope.$on('dmClientsSvc:Index:Failure',@clientsRetrievalFailed)
    @$scope.$on('dmLocationsSvc:Index:Failure',@locationsRetrievalFailed)
    @$scope.$on('dmLocationsSvc:Index:Success',@locationsRetrieved)

    @$scope.$on('dmInterventionsSvc:Get:Failure',@interventionRetrievalFailed) 
    @$scope.$on('dmInterventionsSvc:Get:Success',@interventionRetrieved)
    @$scope.$on('dmInterventionsSvc:Save:Success',@saveSuccess)
    @$scope.$on('dmInterventionsSvc:Save:Failure',@reqFailed)
    @$scope.saveIntervention = angular.bind(this, @saveIntervention)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.clientChanged = angular.bind(this, @clientChanged)
    @$scope.locationChanged = angular.bind(this, @locationChanged)

    @$scope.clients = @dmClientsSvc.index()
    @$scope.selectedClient = undefined
    @$scope.locations = []
    @$scope.selectedLocation = undefined

    @$scope.editMode = @$routeParams.intervention_id?

    if @$scope.editMode
      @$scope.formCaption = "Modifica intervento"
      @$scope.formSubmitCaption = "Aggiorna"
      @$scope.intervention = @dmInterventionsSvc.get(@$routeParams.intervention_id)
    else
      @$scope.formCaption = "Nuovo intervento"
      @$scope.formSubmitCaption = "Crea"
      @$scope.intervention = 
                  user_id: 1
                  data_inoltro_richiesta: new Date()
                  data_intervento: new Date()
                  inizio: new Date()
                  fine: new Date()
				          email: ""
				          contatto: ""
				          descrizione_anomalie: ""
				          descrizione_intervento: ""
				          ore_lavorate_cliente: 0
				          ore_lavorate_laboratorio: 0
				          ore_lavorate_remoto: 0
				          appunti: ""
				          lavoro_completato: true
				          note: ""
				          diritto_di_chiamata: true
				          location_ids: []
      
      @$scope.originalIntervention = undefined

  interventionRetrieved: (evt, response) =>
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @$scope.selectedClient = (c for c in @$scope.clients when c.id is @$scope.intervention.client.id)[0]
    @clientChanged()

  interventionRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving intervention: ' + JSON.stringify(response))
    bootbox.alert("Si e' verificato un errore durante il recupero dell'intervento!")
    @$location.path('/interventions')

  clientsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving clients list')
    bootbox.alert("Si e' verificato un errore durante il recupero dell'elenco clienti!")

  locationsRetrieved: (evt, response) => 
    if @$scope.editMode
      @$scope.selectedLocation = (l for l in @$scope.locations when l.id is @$scope.intervention.location.id)[0]

  locationsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving locations list')
    bootbox.alert("Si e' verificato un errore durante il recupero dell'elenco sedi per il cliente selezionato!")

  clientChanged: ->
    @$log.log("Fetching locations for " + @$scope.selectedClient.ragione_sociale)
    @$scope.locations = @dmLocationsSvc.index(@$scope.selectedClient.id)

  locationChanged: ->
    @$log.log("Location selected: " + @$scope.selectedLocation.descrizione)
    @$scope.intervention.locations_id = [@$scope.selectedLocation.id]

  showValidationErrors: (errors) ->
    @$scope.errors = errors.data

  isDirty: ->
    unless @$scope.originalIntervention?
        return true
    @$log.log('Original: ' + JSON.stringify(@$scope.originalIntervention))
    @$log.log('Selected: ' + JSON.stringify(@$scope.intervention))
    if angular.equals(@$scope.originalIntervention,@$scope.intervention)
      false
    else
      true

  saveIntervention: (intervention) ->
    @dmInterventionsSvc.save(intervention)

  saveSuccess: (events, args) =>
    @$scope.errors = []
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @hideForm()
    bootbox.alert('Dati salvati con successo!')

  reqSuccess: =>
    @$scope.errors = []
    bootbox.alert('Operazione completata!')
    @hideForm()

  reqFailed: (event, args) =>
    @showValidationErrors(args)

  hideForm: ->
    if !@$scope.originalIntervention?
      if !angular.equals(@$scope.originalIntervention, @$scope.intervention)
        @$scope.intervention = angular.copy(@$scope.originalIntervention)
    @$scope.errors = []
