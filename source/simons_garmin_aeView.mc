import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class simons_garmin_aeView extends WatchUi.SimpleDataField {

    // EMA of averageHeartRate so it drifts fractionally instead of jumping whole beats.
    private const HEART_RATE_ALPHA as Float = 0.015;
    private var _smoothedHeartRate as Float?;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Aerobic Efficiency";
    }

    // Restart the EMA whenever the activity timer resets/starts.
    function onTimerReset() as Void {
        _smoothedHeartRate = null;
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

        if (_smoothedHeartRate == null) {
            _smoothedHeartRate = heartRate.toFloat();
        } else {
            _smoothedHeartRate += HEART_RATE_ALPHA * (heartRate - _smoothedHeartRate);
        }

        // Meters traveled per heartbeat, scaled by 60.
        return speed * 3600.0 / _smoothedHeartRate;
    }

}