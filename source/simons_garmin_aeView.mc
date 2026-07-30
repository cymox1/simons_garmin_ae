import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class simons_garmin_aeView extends WatchUi.SimpleDataField {

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Aerobic Efficiency";
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        var speed = info.averageSpeed;
        var heartRate = info.averageHeartRate;

        if (speed == null || heartRate == null || heartRate == 0) {
            return 0;
        }

        // Meters traveled per heartbeat, scaled by 60.
        return speed * 3600.0 / heartRate;
    }

}