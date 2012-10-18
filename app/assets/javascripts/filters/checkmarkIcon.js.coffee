angular.module('dmrpsFilters',[])
  .filter('checkmarkIcon', ->
    f = (input) ->
      if input
        '\u2713'
      else 
        '\u2718'
    return f
  )
