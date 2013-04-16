@app.factory('dmActivitiesSvc',['$rootScope','$resource','$log','appConfig',($rootScope,$resource,$log,appConfig) ->
  new ActivitiesSvc($rootScope,$resource,$log,appConfig)
])

class ActivitiesSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('[ActivitiesSvc] Init ...')
    @activities = @$resource('http://:addr:port/api/:api_ver/:path/:activity_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'activities'
      }
      ,{
        index: {method: 'GET', isArray: true}
        create: {method: 'POST'}
        update: {method: 'PUT'}
        destroy: {method: 'DELETE'}
      }
    )

  notify: (name, args) ->
    @$rootScope.$broadcast('dmActivitiesSvc:'+name,args)

  destroy: (activity) ->
    activity.$destroy({activity_id: activity.id},
      (response) => @notify('Destroy:Success',response),
      (response) => @notify('Destroy:Failure',response)
    )

  save: (activity) ->
    if activity.id?
      activity.$update({activity_id: activity.id},
        (response) => @notify('Save:Success',response),
        (response) => @notify('Save:Failure',response)
      )
    else
      a = new @activities(activity)
      a.$save(
        (response) => @notify('Save:Success',response),
        (response) => @notify('Save:Failure',response)
      )

  index: () ->
    @activities.index(
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )


