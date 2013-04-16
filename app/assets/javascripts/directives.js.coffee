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
              .children()
              .last()
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
  .directive('elencoContatti', ->
    d = {
      restrict: 'E'
      templateUrl: '/assets/clients/contacts.html'
      scope: {
        contatti: '='
        validationErrors: '='
        saveContact: '&'
        deleteContact: '&'
      }
      controller: ($scope, $element, $attrs) ->
        
        $scope.contact = {}
        $scope.originalContact = {}
        $scope.errors = []

        $scope.isDirty = () ->
          if angular.equals($scope.contact,$scope.originalContact)
            false
          else
            true

        $scope.newContact = () ->
          $scope.contact = {}

        $scope.selectContact = (c) ->
          $scope.contact = c
          $scope.originalContact = angular.copy(c)
    }
    return d
  )
  .directive('inputAutocomplete', ->
    d = {
      restrict: 'E'
      template: "<input type='search'>"
      replace: true
      transclude: true
      link: ($scope, $elem, $attrs) ->
        $elem.autocomplete({
          minLength: 3
          source: (term,resp) -> 
            $scope[$attrs.items](term,resp)
          select: (evt, ui) -> 
            $scope[$attrs.selected](evt, ui.item.value)
        })
    }
    return d
  )
