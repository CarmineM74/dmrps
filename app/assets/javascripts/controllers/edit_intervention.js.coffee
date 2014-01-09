class @EditInterventionCtrl
  @inject: ['$scope','$log','dialogsSvc','dmInterventionsSvc','dmClientsSvc','dmLocationsSvc','$routeParams','$location', 'dmContactsSvc', 'dmActivitiesSvc','sessionSvc','usersSvc']
  constructor: (@$scope, @$log, @dialogsSvc, @dmInterventionsSvc,@dmClientsSvc,@dmLocationsSvc,@$routeParams,@$location, @dmContactsSvc, @dmActivitiesSvc, @sessionSvc, @usersSvc) ->
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

    @$scope.$on('dmClientsSvc:Index:Success',@clientsRetrievalSuccess)
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

    @$scope.$on('UsersSvc:Index:Success', @collaboratorsRetrieved)
    @$scope.$on('UsersSvc:Index:Failure', @collaboratorsRetrieveFailed)

    @$scope.saveIntervention = angular.bind(this, @saveIntervention)
    @$scope.cancel = angular.bind(this,@cancel)

    @$scope.isDirty = angular.bind(this, @isDirty)

    @$scope.clientChanged = angular.bind(this, @clientChanged)
    @$scope.locationChanged = angular.bind(this, @locationChanged)

    @$scope.pickActivity = angular.bind(this, @pickActivity)
    @$scope.unpickActivity = angular.bind(this, @unpickActivity)

    @$scope.pickCollaborator = angular.bind(this, @pickCollaborator)
    @$scope.unpickCollaborator = angular.bind(this, @unpickCollaborator)

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
    @$scope.collaboratori_disponibili = []
    @$scope.collaboratori_selezionati = []
    @$scope.canGeneratePDF = false

    @$scope.$on('SessionSvc:CurrentUser:Authenticated', @authenticated)
    @sessionSvc.authenticated_user()

  authenticated: =>
    if @$scope.editMode
      unless @$scope.can('EditInterventions',{fail_and_logout: true})
        return
    else
      unless @$scope.can('CreateInterventions',{fail_and_logout: true})
        return
    @initialize()

  initialize: =>
    if @$scope.editMode
      @$scope.formCaption = "Modifica intervento"
      @$scope.formSubmitCaption = "Aggiorna"
      @$scope.intervention = @dmInterventionsSvc.get(@$routeParams.intervention_id)
      @$scope.canGeneratePDF = true
    else
      @$scope.canGeneratePDF = false
      @$scope.formCaption = "Nuovo intervento"
      @$scope.formSubmitCaption = "Crea"
      @$scope.intervention = {
                  user_id: @sessionSvc.currentUser.id
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
                  ,km_supplementari: 0
				          ,location_ids: []
                  ,collaborators_ids: []
                  ,activities_ids: []
                }
      @$scope.attivita_selezionate = []
      @$scope.originalIntervention = undefined
      @recuperaAttivita()
      @recuperaCollaboratori()

  recuperaAttivita: () ->
    @dmActivitiesSvc.index()

  recuperaCollaboratori: () ->
    @usersSvc.index()

  collaboratorsRetrieved: (evt,args) =>
    if @$scope.editMode
      @$log.log('[collaboratorsRetrieved][editMode] Intervention user: ' + @$scope.intervention.user.id)
      @$scope.allCollaborators = (a for a in args when a.id != @$scope.intervention.user.id)
    else
      @$log.log('[collaboratorsRetrieved][NOT editMode] Intervention user: ' + @sessionSvc.currentUser.id)
      @$scope.allCollaborators = (a for a in args when a.id != @sessionSvc.currentUser.id)
    @aggiornaCollaboratoriDisponibili()

  collaboratorsRetrieveFailed: (evt,args) =>
    @$log.log('[collaboratorsRetrieveFailed]: ' + JSON.stringify(args))
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dei collaboratori!")

  aggiornaCollaboratoriDisponibili: () ->
    @$scope.collaboratori_disponibili = []
    @$scope.collaboratori_disponibili.push(a) for a in @$scope.allCollaborators when @$scope.intervention.collaborators_ids.indexOf(a.id) == -1
    @$scope.collaboratori_selezionati = []
    @$scope.collaboratori_selezionati.push(a) for a in @$scope.allCollaborators when @$scope.intervention.collaborators_ids.indexOf(a.id) != -1

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
    @$scope.intervention.ore_lavorate_cliente = parseFloat(@$scope.intervention.ore_lavorate_cliente)
    @$scope.intervention.ore_lavorate_remoto = parseFloat(@$scope.intervention.ore_lavorate_remoto)
    @$scope.intervention.ore_lavorate_laboratorio = parseFloat(@$scope.intervention.ore_lavorate_laboratorio)
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @$scope.selectedClient = (c for c in @$scope.clients when c.id is @$scope.intervention.client.id)[0]
    @clientChanged()
    @recuperaAttivita()
    @recuperaCollaboratori()

  pickActivity: (a) ->
    @$scope.intervention.activities_ids.push(a.id)
    @aggiornaAttivitaDisponibili()

  unpickActivity: (a) ->
    @$scope.intervention.activities_ids = @$scope.intervention.activities_ids.filter((id) => id isnt a.id)
    @aggiornaAttivitaDisponibili()

  pickCollaborator: (c) ->
    @$scope.intervention.collaborators_ids.push(c.id)
    @aggiornaCollaboratoriDisponibili()

  unpickCollaborator: (c) ->
    @$scope.intervention.collaborators_ids = @$scope.intervention.collaborators_ids.filter((id) => id isnt c.id)
    @aggiornaCollaboratoriDisponibili()

  interventionRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving intervention: ' + JSON.stringify(response))
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dell'intervento!")
    @$location.path('/interventions')

  clientsRetrievalSuccess: (evt, response) =>
    if @$scope.clients.length == 0
      @dialogsSvc.messageBox('Dati insufficienti', "Per poter compilare un rapporto di intervento è necessario definire un'anagrafica clienti con almeno una sede!", [@dialogsSvc.OkBtn])
      if @$scope.can('ManageClients',{})
        @$location.path('/clients')
      else
        @$location.path('/')

  clientsRetrievalFailed: (evt,response) =>
    @$log.log('Error retrieving clients list')
    @dialogsSvc.alert("Si e' verificato un errore durante il recupero dell'elenco clienti!")

  locationsRetrieved: (evt, response) =>
    if @$scope.locations.length == 0
      @dialogsSvc.messageBox('Dati insufficienti', "Per poter compilare un rapporto di intervento è necessario indicare un cliente che abbia almeno una sede definita!", [@dialogsSvc.OkBtn])
      if @$scope.can('ManageClients',{})
        @$location.path('/clients')
      else
        @$location.path('/')
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
    @$scope.intervention.id = args.id
    @$scope.originalIntervention = angular.copy(@$scope.intervention)
    @$scope.errors = []
    @$scope.canGeneratePDF = true
    #@dialogsSvc.alert('Dati salvati con successo!')

  reqFailed: (event, args) =>
    @$scope.errors = args.data

  cancel: ->
    @$scope.errors = []
    @$location.path('/interventions')
