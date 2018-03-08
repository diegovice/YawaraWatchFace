using Toybox.Application as App;

class YawaraWatchFaceApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        System.println("Dozo - start");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        System.println("Dozo - stop");
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new YawaraWatchFaceView() ];
    }

}