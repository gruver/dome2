angular.module('lightsController', ['lights.services'])
    .controller('LightsController', ['$scope', 'Lights',
        function ($scope, Lights) {
            $scope.init = function (address, type) {
                console.log('hello dome');
            };

            $scope.setConfig = function () {
                Lights.setConfig('foo','bar', function(response){
                    console.log(response);
                });
            }
        }]);
