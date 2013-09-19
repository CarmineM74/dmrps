@app.factory('dialogsSvc',['$rootScope','$resource','$log','$modal',($rootScope,$resource,$log,$modal) ->
  new DialogsSvc($rootScope,$resource,$log,$modal)
])

class DialogsSvc
  constructor: (@$rootScope, @$resource, @$log, @$modal) ->
    @$log.log('Initi dialogsSvc ...')

    @OkBtn = {label: 'Ok', result: 'ok'}
    @CancelBtn = {label: 'Cancel', result: 'cancel'}
    @SiBtn = {label: 'Si', result: 'si'}
    @NoBtn = {label: 'No', result: 'no'}
    @AnnullaBtn = {label: 'Annulla', result: 'annulla'}

    @defaultButtons = {}
    @defaultButtons.ok = @OkBtn
    @defaultButtons.cancel = @CancelBtn
    @defaultButtons.si = @SiBtn
    @defaultButtons.no = @NoBtn
    @defaultButtons.annulla = @AnnullaBtn

    @SiNoButtons = [@SiBtn,@NoBtn]
    @OkCancelButtons = [@OkBtn,@CancelBtn]

  alert: (msg) ->
    t = "<div class='modal-body'><p>"+msg+"</p></div>"+
        "<div class='modal-footer'>"+
        "<button ng-click='close()' class='btn btn-primary'>Ok</button>"+
        "</div>"
    opts = {}
    opts.backdrop = true
    opts.template = t
    opts.controller = 'AlertCtrl'
    @$modal.open(opts)

  messageBox: (title, msg, buttons, cb) ->
    t = "<div class='modal-header'><h3>"+title+"</h3></div>"+
        "<div class='modal-body'><p>"+msg+"</p></div>"
    if buttons.length > 0
      t = t + "<div class='modal-footer'>"
      btns = for btnid,b of buttons
                "<button ng-click='close("+'"'+b.result+'"'+")' class='btn'>"+b.label+"</button>"
      t = t + btns.join("")
      t = t + "</div>"
    opts = {}
    opts.backdrop = true
    opts.template = t
    opts.controller = 'AlertCtrl'
    @$modal.open(opts)
      .result.then((result) =>
        if cb?
          cb(result)
      )

class @AlertCtrl
  @inject: ['$scope','$modalInstance']
  constructor: (@$scope,@$modalInstance) ->
    @$scope.close = (result) =>
      @$modalInstance.close(result)

