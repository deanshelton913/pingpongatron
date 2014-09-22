var takePicture = document.querySelector("#take-picture");
takePicture.onchange = function (event) {
    // Get a reference to the taken picture or chosen file
    var files = event.target.files,
        file;
    if (files && files.length > 0) {
        file = files[0];
    }
};