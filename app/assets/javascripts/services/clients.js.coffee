@app.factory('dmClientsSvc',['$rootScope','$resource','$log','appConfig', ($rootScope,$resource,$log,appConfig) ->
	new ClientsSvc($rootScope,$resource,$log,appConfig) 
])

class ClientsSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('Initializing Clients Service ...')
    @clients = @$resource('http://:addr:port/api/:api_ver/:path/:client_id'
      ,{
        addr: appConfig.serverAddr
        port: appConfig.serverPort
        api_ver: appConfig.api_ver
        path: 'clients'
      }
      ,{index: {method: 'GET', isArray: true}
      ,create: {method: 'POST'}
      ,update: {method: 'PUT'}
      ,destroy: {method: 'DELETE'}}
    )

  notify: (name,args) ->
    @$rootScope.$broadcast('dmClientsSvc:'+name,args)

  destroy: (client) ->
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
      c = new @clients(client)
      c.$save(
        (response) => @notify('Save:Success',response), 
        (response) => @notify('Save:Failure',response)
      )  

  index: ->
    @clients.index(
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )
