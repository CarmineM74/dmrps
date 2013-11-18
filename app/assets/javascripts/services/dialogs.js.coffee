@app.factory('dialogsSvc',['$rootScope','$resource','$log','$dialog',($rootScope,$resource,$log,$dialog) ->
  new DialogsSvc($rootScope,$resource,$log,$dialog)
])

class DialogsSvc
  constructor: (@$rootScope, @$resource, @$log, @$dialog) ->
    @$log.log('Init dialogsSvc ...')

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
        "<button ng-click='close()' class='btn btn-primary'>Ok</button>"
    opts = {}
    opts.backdrop = true
    opts.backdropClick = true
    opts.template = t
    opts.controller = 'AlertCtrl'
    @$dialog.dialog(opts).open()

  messageBox: (title, msg, buttons, cb) ->
    @$dialog.messageBox(title,msg,buttons)
      .open()
      .then((result) =>
        if cb?
          cb(result)
      )

class @AlertCtrl
  @inject: ['$scope','dialog']
  constructor: (@$scope,@dialog) ->
    @$scope.close = () =>
      @dialog.close()

