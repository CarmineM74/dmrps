angular.module('directivesService',[])
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
          return if value?.errors == undefined
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

        to_uppercase = (cur_value) =>
          return '' if !cur_value?
          new_value = cur_value.toUpperCase()
          if (cur_value != new_value)
            ctrl.$setViewValue(new_value)
            ctrl.$render()
          new_value

        ctrl.$parsers.push(to_uppercase)
        to_uppercase(scope[attrs.ngModel])
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
  .directive('elencoAttivita', ->
    d = {
      restrict: 'E'
      templateUrl: '/assets/activities/activities.html'
      scope: {
        attivita: '='
        showDelete: '='
        showPick: '='
        selectActivity: '&'
        pickActivity: '&'
        deleteActivity: '&'
      }
      controller: ($scope, $element, $attrs) ->
        $scope.nrOfPages = 0
        $scope.currentPage = 1
        $scope.itemsPerPage = 10
        $scope.activities = []

        $scope.pageChanged = (page) ->
          $scope.nrOfPages = Math.floor($scope.attivita.length / $scope.itemsPerPage)
          if ($scope.attivita.length % $scope.itemsPerPage) != 0
            $scope.nrOfPages += 1
          $scope.currentPage = page
          start = ($scope.currentPage - 1) * $scope.itemsPerPage
          stop = start + ($scope.itemsPerPage) - 1
          if stop > $scope.attivita.length
            stop = $scope.attivita.length - 1
          $scope.activities = $scope.attivita[start..stop]


        $scope.$watch('attivita',(value) ->
          $scope.attivita = value
          unless value?
            return false
          $scope.pageChanged(1)
        )

    }
    return d
  )
