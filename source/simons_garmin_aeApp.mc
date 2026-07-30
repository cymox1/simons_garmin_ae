import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class simons_garmin_aeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new simons_garmin_aeView() ];
    }

}

function getApp() as simons_garmin_aeApp {
    return Application.getApp() as simons_garmin_aeApp;
}