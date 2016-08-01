angular.module('lightsService', [])
    .factory('Lights', ['API', '$timeout', '$rootScope', function (API, $timeout, $rootScope) {
        var s = {};

        s.setConfig = function (key, value, callback) {
            payload = {key: key, value: value}
            API.request('POST', 'lights', payload, function(response){
                console.log('service response: ' + response);
                if (callback){
                    callback(response);
                }
            })
        };

        return s;
}]);
