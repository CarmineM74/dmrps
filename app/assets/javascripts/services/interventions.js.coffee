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

  save: (intervention,contact_name) ->
    if intervention.id?
      intervention.$update({intervention_id: intervention.id, contact_name: contact_name},
        (response) => @notify('Save:Success',response)
        (response) => @notify('Save:Failure',response)
      )
    else
      r = new @interventions(intervention)
      r.$save({contact_name: contact_name},
        (response) => @notify('Save:Success',response), 
        (response) => @notify('Save:Failure',response)
      )  

  fixDateTime: (i) ->
    i.inizio = new Date(i.inizio)
    i.fine = new Date(i.fine)
    i.data_inoltro_richiesta = new Date(i.data_inoltro_richiesta)
    i.data_intervento = new Date(i.data_intervento)
    i


  index: (query) ->
    rs = @interventions.index({query: query},
      (response) => 
        response = response.map (i) =>
            @fixDateTime(i)
        @notify('Index:Success',response)
      ,(response) => @notify('Index:Failure',response)
    )

  get: (intervention_id) ->
    i = @interventions.get({intervention_id},
      (response) => 
        response = @fixDateTime(response)
        @notify('Get:Success', response)
      ,(response) => @notify('Get:Failure', response)
    )

