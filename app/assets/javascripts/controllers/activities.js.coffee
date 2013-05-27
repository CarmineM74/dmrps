class @ActivitiesCtrl
  @inject: ['$scope','$log','dialogsSvc','dmActivitiesSvc']
  constructor: (@$scope,@$log,@dialogsSvc,@dmActivitiesSvc) ->
    @$log.log('[ActivitiesCtrl] Init ...')

    @$scope.$on('dmActivitiesSvc:Index:Success', @activitiesRetrieved)
    @$scope.$on('dmActivitiesSvc:Index:Failure', @activitiesRetrieveFailed)
    @$scope.$on('dmActivitiesSvc:Save:Success', @activitySaved)
    @$scope.$on('dmActivitiesSvc:Save:Failure', @activitySaveFailed)
    @$scope.$on('dmActivitiesSvc:Destroy:Success', @activityDestroyed)
    @$scope.$on('dmActivitiesSvc:Destroy:Failure', @activityDestroyFailed)

    @$scope.isDirty = angular.bind(this, @isDirty)
    @$scope.pageChanged = angular.bind(this, @pageChanged)
    @$scope.fetchAll = angular.bind(this, @fetchAll)
    @$scope.selectActivity = angular.bind(this, @selectActivity)
    @$scope.newActivity = angular.bind(this, @newActivity)
    @$scope.saveActivity = angular.bind(this, @saveActivity)
    @$scope.removeActivity = angular.bind(this, @removeActivity)

    @$scope.errors = []
    @$scope.activity = undefined
    @$scope.originalActivity = undefined

    @$scope.allActivities = []
    @$scope.originalActivity = undefined

    @fetchAll()

  isDirty: () ->
    if angular.equals(@$scope.activity,@$scope.originalActivity)
      false
    else
      true

  fetchAll: () ->
    @dmActivitiesSvc.index()

  selectActivity: (a) ->
    @$scope.activity = angular.copy(a) 
    @$scope.originalActivity = angular.copy(a)

  newActivity: () ->
    @$scope.activity = { descrizione: '' }
    @$scope.originalActivity = undefined

  saveActivity: (a) ->
    @dmActivitiesSvc.save(a)

  removeActivity: (a) ->
    @dmActivitiesSvc.destroy(a)

  activityDestroyed: (evt, args) =>
    @fetchAll()

  activityDestroyFailed: (evt, args) =>
    @$log.log('[activityDestroyFailed]: ' + JSON.stringify(args))
    @dialogsSvc.alert("Impossibile rimuovere l'attivita' selezionata:<br/>"+args.data.error_msg)

  activitySaved: (evt, args) =>
    @fetchAll()

  activitySaveFailed: (evt, args) =>
    @$scope.errors = args.data

  activitiesRetrieved: (evt, args) =>
    @$scope.allActivities = args
    @$scope.activity = undefined
    @$scope.originalActivity = undefined

  activitiesRetrieveFailed: (evt, args) =>
    @$log.log('[activitiesRetrieveFalied]: ' + JSON.stringify(args))
    @$scope.allActivities = []
    @$scope.activity = undefined
    @$scope.originalActivity = undefined
