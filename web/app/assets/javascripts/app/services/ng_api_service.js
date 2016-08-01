angular.module('apiService', []).factory('API', ['$http', '$timeout', '$rootScope', function ($http, $timeout, $rootScope) {
    var s = {};

    s.request = function (method, url, payload, callback) {
        // Spot check for required params
        if (!method) {
            callback({error: -100, message: "HTTP Method Required"});
        }
        if (!url) {
            callback({error: -101, message: "HTTP URL Required"});
        }

        // Default Request options
        var options = {
            withCredentials: true,
            method: method,
            url: url
        };

        // Set the payload intelligently based on method
        if (!payload) {
            payload = {};
        }
        if (method == 'GET' || method == 'DELETE') {
            var interpolatedParams = {};
            _.each(payload, function (paramValue, paramKey) {
                if (_.isArray(paramValue)) {
                    var arrayParamKey = paramKey + '[]';
                    interpolatedParams[arrayParamKey] = paramValue;
                } else {
                    interpolatedParams[paramKey] = paramValue;
                }
            });

            options.params = interpolatedParams;
        } else {
            options.data = payload;
        }

        // Setup a shared response callback
        var process = function (success, data, status) {
            if (!data) {
                data = {};
            }

            // Ensure the callback gets a normalized data hash
            if (success && status == 200) {
                if (data.error === undefined || data.error === null) {
                    data.error = 0;
                }
            } else {
                if (typeof data != 'object') {
                    data = {};
                }

                // Make sure there is an error code
                if (data.error == 0 || data.error === undefined || data.error === null) {
                    if (status) {
                        data.error = status;
                    } else {
                        data.error = 500;
                    }
                }

                // Make sure there is an error message
                if (!data.message) {
                    data.message = "Communication Error"
                }
            }

            // Send a response to the callback
            if (callback) {
                $timeout(function () {
                    callback(data);
                });
            }
        };

        // Execute the actual HTTP request
        $http(options)
            .success(function (data, status) {
                process(true, data, status);
            })
            .error(function (data, status, headers) {
                process(false, data, status);
            });
    };

    s.encodeQueryString = function (params) {
        var queryString = '?';

        _.each(params, function (value, key) {
            if (key && value) {
                var urlKey = encodeURIComponent(key);
                if (_.isArray(value)) {
                    _.each(value, function (item) {
                        queryString += urlKey + '[]=' + encodeURIComponent(item) + '&';
                    });
                } else {
                    queryString += urlKey + '=' + encodeURIComponent(value) + '&';
                }
            }
        });

        return queryString;
    };

    return s;
}]);
