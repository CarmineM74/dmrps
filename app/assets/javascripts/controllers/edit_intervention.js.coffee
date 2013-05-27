class @EditInterventionCtrl
  @inject: ['$scope','$log','dialogsSvc','dmInterventionsSvc','dmClientsSvc','dmLocationsSvc','$routeParams','$location', 'dmContactsSvc', 'dmActivitiesSvc']
  constructor: (@$scope, @$log, @dialogsSvc, @dmInterventionsSvc,@dmClientsSvc,@dmLocationsSvc,@$routeParams,@$location, @dmContactsSvc, @dmActivitiesSvc) ->
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
    @$scope.$on('dmContactsSvc:Index:Success',@contactsRetrieved)

    @$scope.$on('dmActivitiesSvc:Index:Success', @activitiesRetrieved)
    @$scope.$on('dmActivitiesSvc:Index:Failure', @activitiesRetrieveFailed)

    @$scope.saveIntervention = angular.bind(this, @saveIntervention)
    @$scope.cancel = angular.bind(this,@cancel)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.clientChanged = angular.bind(this, @clientChanged)
    @$scope.locationChanged = angular.bind(this, @locationChanged)

    @$scope.pickActivity = angular.bind(this, @pickActivity)
    @$scope.unpickActivity = angular.bind(this, @unpickActivity)

    @$scope.getContacts = angular.bind(this, @getContacts)
    @$scope.contactSelected = angular.bind(this, @contactSelected)

    @$scope.clients = @dmClientsSvc.index('')
    @$scope.selectedClient = undefined
    @$scope.locations = []
    @$scope.selectedLocation = undefined
    @$scope.contacts = []
    @$scope.contact_names = []

    @$scope.editMode = @$routeParams.intervention_id?
    @$scope.attivita_disponibili = []
    @$scope.attivita_selezionate = []

    if @$scope.editMode
      @$scope.formCaption = "Modifica intervento"
      @$scope.formSubmitCaption = "Aggiorna"
      @$scope.intervention = @dmInterventionsSvc.get(@$routeParams.intervention_id)
    else
      @$scope.formCaption = "Nuovo intervento"
      @$scope.formSubmitCaption = "Crea"
      @$scope.intervention = {
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
                  activities_ids: []
                }
      @$scope.attivita_selezionate = []
      @$scope.originalIntervention = undefined
      @recuperaAttivita()

  recuperaAttivita: () ->
    @dmActivitiesSvc.index()

  activitiesRetrieved: (evt, args) =>
    @$scope.allActivities = args
    @aggiornaAttivitaDisponibili()

  aggiornaAttivitaDisponibili: () ->
    @$scope.attivita_disponibili = []
    @$scope.attivita_disponibili.push(a) for a in @$scope.allActivities when @$scope.intervention.activities_ids.indexOf(a.id) == -1
    @$scope.attivita_selezionate = []
    @$scope.attivita_selezionate.push(a) for a in @$scope.allActivities when @$scope.intervention.activities_ids.indexOf(a.id) != -1


  activitiesRetrieveFailed: (evt, args) =>
    @$log.log('[activitiesRetrieveFailed]: ' + JSON.stringify(args))
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero delle attivita'!")

  interventionRetrieved: (evt, response) =>
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @$scope.selectedClient = (c for c in @$scope.clients when c.id is @$scope.intervention.client.id)[0]
    @clientChanged()
    @recuperaAttivita()

  pickActivity: (a) ->
    @$scope.intervention.activities_ids.push(a.id)
    @aggiornaAttivitaDisponibili()

  unpickActivity: (a) ->
    @$scope.intervention.activities_ids = @$scope.intervention.activities_ids.filter((id) => id isnt a.id)
    @aggiornaAttivitaDisponibili()

  interventionRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving intervention: ' + JSON.stringify(response))
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dell'intervento!")
    @$location.path('/interventions')

  clientsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving clients list')
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dell'elenco clienti!")

  locationsRetrieved: (evt, response) => 
    if @$scope.editMode
      @$scope.selectedLocation = (l for l in @$scope.locations when l.id is @$scope.intervention.location.id)[0]

  locationsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving locations list')
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dell'elenco sedi per il cliente selezionato!")

  clientChanged: ->
    @$log.log("Fetching locations for " + @$scope.selectedClient.ragione_sociale)
    @$scope.locations = @dmLocationsSvc.index(@$scope.selectedClient.id)
    @dmContactsSvc.index(@$scope.selectedClient.id)
    if !@$scope.editMode
      @$scope.intervention.diritto_di_chiamata = @$scope.selectedClient.diritto_di_chiamata

  contactsRetrieved: (evt, args) =>
    @$scope.contacts = args
    @$scope.contact_names.push(c.name) for c in args 

  getContacts: (term, resp) =>
    resp(c for c in @$scope.contact_names when c.toLowerCase().contains(term.term.toLowerCase()))

  contactSelected: (evt,name) =>
    @$scope.intervention.contatto = name
    @$scope.$apply(() =>
      @$scope.intervention.email = c.email for c in @$scope.contacts when (c.name.toLowerCase() == name.toLowerCase())
    )

  locationChanged: ->
    @$log.log("Location selected: " + @$scope.selectedLocation.descrizione)
    @$scope.intervention.location_ids = [@$scope.selectedLocation.id]

  isDirty: ->
    @$log.log('[Intervention] Original: ' + JSON.stringify(@$scope.originalIntervention))
    @$log.log('[Intervention] Selected: ' + JSON.stringify(@$scope.intervention))
    if angular.equals(@$scope.originalIntervention,@$scope.intervention)
      false
    else
      true

  saveIntervention: (intervention) ->
    @dmInterventionsSvc.save(intervention,@$scope.intervention.contatto)

  saveSuccess: (events, args) =>
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @$scope.errors = []
    #@dialogsSvc.alert('Dati salvati con successo!')

  reqFailed: (event, args) =>
    @$scope.errors = args.data

  cancel: ->
    @$scope.errors = []
    @$location.path('/interventions')
