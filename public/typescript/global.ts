// VAR Operation: "delete", "update".
// VAR Endpoint: Endpoint that will be called.
// VAR Value: Value to pass to endpoint using operation.
function crudOperation(operation, endpoint, value) {
    const newEndpoint = endpoint + "/" + value;
    var xhr = new XMLHttpRequest();

    xhr.onload = function(e) {
        if (xhr.status != 200) {
            var responseText = {"message": "Undefined"};
            if (xhr.status == 404) {
                responseText["message"] = "Object not found.";
            } else {
                responseText = JSON.parse(xhr.response)
            }
            alert("Operation has failed.\n\nFailure reason: '" + responseText["message"] + "'.\nStatus code: " + xhr.status + ".");
        } else {
            alert("Operation successful.");
        }
    }

    // Validate
    const operationValidationSet = ['delete', 'update'];
    if (operationValidationSet.indexOf(operation) > -1) {
        if (confirm("Really perform '" + operation + "' on '" + newEndpoint + "'?")) {
            const URL = window.location.origin + "/" + newEndpoint;
            console.info("Perorming '" + operation + "' on '" + URL + "'.");

            xhr.open(operation, URL);
            xhr.send();
        } else {
            console.info("crudOperation(): User has aborted action.")
        }
    } else {
        console.error("crudOperation(): Validation of param 'operation' failed.");
    }
}