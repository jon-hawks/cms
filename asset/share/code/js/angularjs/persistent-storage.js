/*-----------------------------------------------------------------------------\
| Get, set, or destroy persistent storage variables in AngularJS.              |
\-----------------------------------------------------------------------------*/
.factory("sessionService", ["$http", function($http){
    return {
            get: function(key){
            return JSON.parse(localStorage.getItem(key));
        },
            set: function(key, value){
            return localStorage.setItem(key, JSON.stringify(value));
        },
            destroy: function(key){
            return localStorage.removeItem(key);
        },
    }
}])
