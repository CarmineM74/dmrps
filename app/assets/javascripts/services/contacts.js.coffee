@app.factory('dmContactsSvc',['$rootScope','$resource','$log','appConfig',($rootScope,$resource,$log,appConfig) ->
  new ContactsSvc($rootScope,$resource,$log,appConfig)
])

class ContactsSvc
  constructor: (@$rootScope,@$resource,@$log,@appConfig) ->
    @$log.log('[ContactsSvc] Init ...')

    @contacts = @$resource('http://:addr:port/api/:api_ver/:path/:client_id/contacts/:id'
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

  notify: (name, args) ->
    @$rootScope.$broadcast('dmContactsSvc:'+name,args)

  index: (client_id) ->
    contacts = @contacts.index({client_id: client_id},
      (response) => @notify('Index:Success',response),
      (response) => @notify('Index:Failure',response)
    )

  save: (client_id, contact) ->
    if contact.id?
      contact.$update({client_id: client_id, id: contact.id},
        (response) => @notify('Save:Success',response),
        (response) => @notify('Save:Failure',response)
      )
    else
      c = new @contacts(contact)
      c.client_id = client_id
      c.$save({client_id: client_id},
        (response) => @notify('Save:Success',response),
        (response) => @notify('Save:Failure',response)
      )

  destroy: (contact) ->
    contact.$destroy({client_id: contact.client_id, id: contact.id},
      (response) => @notify('Destroy:Success', response),
      (response) => @notify('Destroy:Failure',response)
    )
