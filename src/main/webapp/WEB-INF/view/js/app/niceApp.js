
		var app = angular.module("myApp", []);
		app.controller("myCtrl", function($scope, $http){
			
			$scope.ussdResponse = "";
			$scope.myResponse = "";
			
			$scope.ussdRequest = {
		            mobile : "",
		            sessionId : "",
		            type : "",
		            message : "Enter *100# as SCHOOLiha Short Code",//even if the text-input is empty!
		            operator : "",
		            sequence : -1,
		            clientState : "",
		            serviceCode : ""
		        };
		    
		    document.getElementById("my_response").focus();// Setting focus to the Text input
			
			// Manipulations when data is sent and/or received:
			$scope.submitUssdRequest = function() {
		        
		        var method = "";
		        var url = "";
		        $scope.ussdRequest.message = $scope.myResponse;// Here we catch the entered value before submit
		        $http({
		            method : "POST",
		            url : "http://localhost:8080/schooliha/ussdrequest",
		            data : angular.toJson($scope.ussdRequest),
		            headers : {
		                "Content-Type" : "application/json"
		            }
		        }).then(function successCallback(response) {
		            $scope.ussdResponse = response.data;
		            
		            // Loading back the response from the web-service
		            if($scope.ussdResponse!=null){
			            if ($scope.ussdResponse.type != "") {
			            	$scope.ussdRequest.type = $scope.ussdResponse.type;
			            }
			            if ($scope.ussdResponse.message != ""){
			            	$scope.ussdRequest.message = $scope.ussdResponse.message;
			            }
			            if ($scope.ussdResponse.clientState != ""){
			            	$scope.ussdRequest.clientState = $scope.ussdResponse.clientState;
			            }
		            }
		            
		            // Clearing the input after sending the request...
		            _clearFormData();
		        }, _error );
		    };
		    
		    /* Private Methods */
	
		    function _success(response) {
		        //_refreshResponseData();
		        _clearFormData()
		    }
	
		    function _error(response) {
		        console.log(response.statusText);
		    }
	
		    //Clear the input-text
		    function _clearFormData() {
		        $scope.myResponse = "";
		    };
		});