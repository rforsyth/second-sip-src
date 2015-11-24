
angular.module('app', [])
  .controller('LocaleController', function($scope, $locale) {
    $scope.locale = $locale.id;
  });
