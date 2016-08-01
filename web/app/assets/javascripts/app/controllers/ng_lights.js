angular.module('lightsController', ['lights.services'])
    .controller('LightsController', ['$scope', 'Lights',
        function ($scope, Lights) {
            $scope.init = function (address, type) {
                console.log('hello dome');
            };

            $scope.setConfig = function () {
                var key = 'color'
                var value = Math.floor(Math.random()*(100-1+1)+1);

                Lights.setConfig(key, value, function(response){
                    console.log(response);
                });
            }
        }]);
