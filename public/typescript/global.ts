// VAR Operation: "delete", "update".
// VAR Endpoint: Endpoint that will be called.
// VAR Value: Value to pass to endpoint using operation.
function crudOperation(operation: string, endpoint: string, value: string) {
    const newEndpoint = endpoint + "/" + value;
    var xhr = new XMLHttpRequest();

    // Request handling
    xhr.onload = function(e) {
        if (xhr.status != 200) {
            var responseText = {"message": "Undefined"};
            switch (xhr.status) {
                case 404: responseText["message"] = "Object not found."; break;
                case 500: responseText["message"] = "Server error."; break;
                default: responseText = JSON.parse(xhr.response);
            }

            alert("Operation has failed.\n\nFailure reason: " + responseText["message"] + "\nStatus code: " + xhr.status + "");
        } else {
            alert("Operation successful.");
            window.location = window.origin;
        }
    }

    // Validate
    const operationValidationSet = ['delete', 'update'];
    if (operationValidationSet.indexOf(operation) > -1) {
        if (confirm("Really perform '" + operation + "' on '" + newEndpoint + "'?")) {
            const URL = window.location.origin + "/" + newEndpoint;
            console.info("Performing '" + operation + "' on '" + URL + "'.");

            xhr.open(operation, URL);
            if (operation == 'delete') {
                var auth = JSON.stringify({'authentication': prompt("Enter authentication code.")});
                xhr.send(auth);
            } else {
                xhr.send();
            }
        } else {
            console.info("crudOperation(): User has aborted action.")
        }
    } else {
        console.error("crudOperation(): Validation of param 'operation' failed.");
    }
}