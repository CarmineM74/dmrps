@app.factory('dmLocationsSvc',['$rootScope','$resource','$log','appConfig', ($rootScope,$resource,$log,appConfig) ->
	new LocationsSvc($rootScope,$resource,$log,appConfig) 
])

class LocationsSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('Initializing Locations Service ...')
    @locations = @$resource('http://:addr:port/api/:api_ver/:path/:location_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'locations'
      }
      ,{index: {method: 'GET', isArray: true}
      ,create: {method: 'POST'}
      ,update: {method: 'PUT'}
      ,destroy: {method: 'DELETE'}}
    )

  notify: (name,args) ->
    @$rootScope.$broadcast('dmLocationsSvc:'+name,args)

  destroy: (location) ->
    client.$destroy({client_id: client.id},
      (response) => @notify('Destroy:Success',response),
      (response) => @notify('Destroy:Failure',response)
    )

  save: (client) ->
    if client.id?
      client.$update({client_id: client.id},
        (response) => @notify('Save:Success',response)
        (response) => @notify('Save:Failure',response)
      )
    else
      c = new @locations(client)
      c.$save(
        (response) => @notify('Save:Success',response), 
        (response) => @notify('Save:Failure',response)
      )  

  index: (client_id) ->
    @locations.index({client_id: client_id}
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )
