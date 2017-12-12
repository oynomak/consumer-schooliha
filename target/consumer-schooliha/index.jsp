<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
	<script type="text/javascript">
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
	</script>
	<title>USSD</title>
</head>

	<body>
		<div ng-app="myApp" ng-controller="myCtrl">
			<form ng-submit="submitUssdRequest()">
				<table>
					<tr>
						<td><h2>USSD Simulator JSP</h2></td>
					</tr>
					<tr>
						<td>
							<label id="my_display">{{ ussdRequest.message }}</label>
						</td>
					</tr>
					<tr>
						<td><input type="text" id="my_response" autocomplete="off" ng-model="myResponse" size="10" autofocus/>
						<input type="submit" id="my_send_button" value="SEND"/></td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>