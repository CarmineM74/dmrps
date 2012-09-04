angular.module('directivesService',[])
  .directive('showValidationErrors', ->
    d = {
      restrict: 'A'
      link: (scope, element, attrs, ctrl) ->
        scope.$watch(attrs.errors, (value) ->
          console.log('Errors: ' + JSON.stringify(value))
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
