angular.module('directivesService',[])
  .directive('showValidationErrors', ->
    d = {
      restrict: 'A'
      link: (scope, element, attrs, ctrl) ->
        scope.$watch(attrs.errors, (value) ->
          console.log('[showValidationErrors] Errors: ' + JSON.stringify(value))
          element.find('.control-group')
            .removeClass('error')
            .find('span.help-block')
            .remove()
          for k,v of value.errors
            element.find('.control-group.'+k)
              .addClass('error')
              .find('input')
              .after("<span class='help-block'>"+v+"</span>")
        )
    }
    return d
  )
  .directive('toUppercase', ->
    d = {
      restrict: 'A'
      require: 'ngModel'
      link: (scope, element, attrs, ctrl) ->
        cur_value = element.val().toUpperCase()

        element.bind('blur', ->
          scope.$apply( -> ctrl.$setViewValue(element.val().toUpperCase()))
          ctrl.$render()
        )

        ctrl.$render = -> 
          element.val(ctrl.$viewValue)

        ctrl.$setViewValue(cur_value)
    }
    return d
  )
  .directive('elencoSedi', ->
    d = {
      restrict: 'EA'
      templateUrl: '/assets/clients/locations.html'
      scope: {
        sedi: '='
        nuovaSedeClick: "&"
        modificaSedeClick: "&"
        eliminaSedeClick: "&"
      }
    }
    return d
  )
