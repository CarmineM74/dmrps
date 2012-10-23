@app.factory('dmInterventionsSvc',['$rootScope','$resource','$log','appConfig',($rootScope,$resource,$log,appConfig) ->
	new InterventionsSvc($rootScope,$resource,$log,appConfig) 
])

class InterventionsSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('Initializing Interventions Service ...')
    @interventions = @$resource('http://:addr:port/api/:api_ver/:path/:intervention_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'interventions'
      }
      ,{index: {method: 'GET', isArray: true}
      ,get: {method: 'GET' }
      ,create: {method: 'POST'}
      ,update: {method: 'PUT'}
      ,destroy: {method: 'DELETE'}}
    )

  notify: (name,args) ->
    @$rootScope.$broadcast('dmInterventionsSvc:'+name,args)

  destroy: (intervention) ->
    intervention.$destroy({intervention_id: intervention.id},
      (response) => @notify('Destroy:Success',response),
      (response) => @notify('Destroy:Failure',response)
    )

  save: (intervention) ->
    if intervention.id?
      intervention.$update({intervention_id: intervention.id},
        (response) => @notify('Save:Success',response)
        (response) => @notify('Save:Failure',response)
      )
    else
      r = new @interventions(intervention)
      r.$save(
        (response) => @notify('Save:Success',response), 
        (response) => @notify('Save:Failure',response)
      )  

  index: ->
    rs = @interventions.index(
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )

  get: (intervention_id) ->
    i = @interventions.get({intervention_id},
      (response) => @notify('Get:Success', response),
      (response) => @notify('Get:Failure', response)
    )

