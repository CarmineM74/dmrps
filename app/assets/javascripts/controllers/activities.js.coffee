class @ActivitiesCtrl
  @inject: ['$scope','$log','dmActivitiesSvc']
  constructor: (@$scope,@$log,@dmActivitiesSvc) ->
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

    @initPagination()
    @fetchAll()

  isDirty: () ->
    if angular.equals(@$scope.activity,@$scope.originalActivity)
      false
    else
      true

  initPagination: () ->
    @$scope.activities = []
    @$scope.allActivities = []
    @$scope.originalActivity = undefined
    @$scope.itemsPerPage = 10
    @$scope.currentPage = 1
    @$scope.nrOfPages = 0

  pageChanged: (page) ->
    @$scope.nrOfPages = Math.floor(@$scope.allActivities.length / @$scope.itemsPerPage)
    if (@$scope.allActivities.length % @$scope.itemsPerPage) != 0
      @$scope.nrOfPages += 1
    @$scope.currentPage = page
    start = (@$scope.currentPage - 1) * @$scope.itemsPerPage
    stop = start + (@$scope.itemsPerPage) - 1
    if stop > @$scope.allActivities.length
      stop = @$scope.allActivities.length - 1
    @$scope.activities = @$scope.allActivities[start..stop]

  fetchAll: () ->
    @dmActivitiesSvc.index()
    @pageChanged(1)

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
    @initPagination()
    @fetchAll()

  activityDestroyFailed: (evt, args) =>
    @$log.log('[activityDestroyFailed]: ' + JSON.stringify(args))
    bootbox.alert("Impossibile rimuovere l'attivita' selezionata!")

  activitySaved: (evt, args) =>
    @initPagination()
    @fetchAll()

  activitySaveFailed: (evt, args) =>
    @$scope.errors = args.data

  activitiesRetrieved: (evt, args) =>
    @$scope.allActivities = args
    @$scope.activity = undefined
    @$scope.originalActivity = undefined
    @pageChanged(1)

  activitiesRetrieveFailed: (evt, args) =>
    @$log.log('[activitiesRetrieveFalied]: ' + JSON.stringify(args))
    @$scope.activities = []
    @$scope.activity = undefined
    @$scope.originalActivity = undefined
