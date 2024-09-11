import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Timer;

import Toybox.Lang;

using Toybox.System;

class GarminEUCView extends WatchUi.View {
  private var cDrawables as Dictionary<Symbol, Drawable> = {};
  function initialize() {
    View.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.HomeLayout(dc));

    // Label drawables
    cDrawables[:TimeDate] = View.findDrawableById("TimeDate");
    cDrawables[:SpeedNumber] = View.findDrawableById("SpeedNumber");
    cDrawables[:BatteryNumber] = View.findDrawableById("BatteryNumber");
    cDrawables[:TemperatureNumber] = View.findDrawableById("TemperatureNumber");
    cDrawables[:BottomSubtitle] = View.findDrawableById("BottomSubtitle");
    // And arc drawables
    cDrawables[:SpeedArc] = View.findDrawableById("SpeedDial"); // used for PMW
    cDrawables[:BatteryArc] = View.findDrawableById("BatteryArc");
    cDrawables[:TemperatureArc] = View.findDrawableById("TemperatureArc");
    cDrawables[:RecordingIndicator] = View.findDrawableById("RecordingIndicator");
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
    var CurrentTime = System.getClockTime();
    var TimeView = cDrawables[:TimeDate] as Text;
    TimeView.setText(
      CurrentTime.hour.format("%d") + ":" + CurrentTime.min.format("%02d")
    );

    TimeView.setColor(Graphics.COLOR_WHITE);
  }

  // Update the view
  function onUpdate(dc as Toybox.Graphics.Dc) {
    // Update label drawables
    var TimeDate = cDrawables[:TimeDate] as Text;
    var BatteryNumber = cDrawables[:BatteryNumber] as Text;
    var TemperatureNumber = cDrawables[:TemperatureNumber] as Text;
    var BottomSubtitle = cDrawables[:BottomSubtitle] as Text;
    var SpeedNumber = cDrawables[:SpeedNumber] as Text;
    var SpeedArc = cDrawables[:SpeedArc] as ArcRenderer;
    var BatteryArc = cDrawables[:BatteryArc] as ArcRenderer;
    var TemperatureArc = cDrawables[:TemperatureArc] as ArcRenderer;

    TimeDate.setText(
      // Update time
      System.getClockTime().hour.format("%d") +
        ":" +
        System.getClockTime().min.format("%02d")
    );
    var batteryPercentage = eucData.getBatteryPercentage();

    BatteryNumber.setText(
      valueRound(batteryPercentage, "%.1f") + "%"
    );
    TemperatureNumber.setText(
      valueRound(eucData.temperature, "%.1f").toString() + "°C"
    );
    BottomSubtitle.setText(diplayStats());
    /* To implement later
            switch (AppStorage.getSetting("BottomSubtitleData")) {
                case 0: cDrawables[:BottomSubtitle].setText(WheelData.wheelModel); break;
                case 1: cDrawables[:BottomSubtitle].setText(Lang.format("$1$% / $2$%", [WheelData.pwm, WheelData.maxPwm])); break;
                case 2: cDrawables[:BottomSubtitle].setText(Lang.format("$1$ / $2$", [WheelData.averageSpeed, WheelData.topSpeed])); break;
                case 3: cDrawables[:BottomSubtitle].setText(WheelData.rideTime); break;
                case 4: cDrawables[:BottomSubtitle].setText(WheelData.rideDistance.toString()); break;
            }
        */

    var speedNumberStr = "";

    if (eucData.mainNumber == 0) {
      var speedNumberVal = "";
      speedNumberVal = eucData.correctedSpeed;
      if (speedNumberVal > 100) {
        speedNumberStr = valueRound(eucData.correctedSpeed, "%d").toString();
      } else {
        speedNumberStr = valueRound(eucData.correctedSpeed, "%.1f").toString();
      }
    }
    if (eucData.mainNumber == 1) {
      var speedNumberVal;
      speedNumberVal = eucData.PWM;
      if (speedNumberVal > 100) {
        speedNumberStr = valueRound(eucData.PWM, "%d").toString();
      } else {
        speedNumberStr = valueRound(eucData.PWM, "%.1f").toString();
      }
    }
    if (eucData.mainNumber == 2) {
      var speedNumberVal;
      speedNumberVal = eucData.getBatteryPercentage();
      if (speedNumberVal > 100) {
        speedNumberStr = valueRound(speedNumberVal, "%d").toString();
      } else {
        speedNumberStr = valueRound(speedNumberVal, "%.1f").toString();
      }
    }
    SpeedNumber.setText(speedNumberStr);
    //cDrawables[:SpeedArc].setValues(WheelData.currentSpeed.toFloat(), WheelData.speedLimit);
    if (eucData.topBar == 0) {
      SpeedArc.setValues(eucData.PWM.toFloat(), 100);
    } else {
      SpeedArc.setValues(
        eucData.correctedSpeed.toFloat(),
        eucData.maxDisplayedSpeed
      );
    }

    BatteryArc.setValues(batteryPercentage, 100);
    TemperatureArc.setValues(
      eucData.temperature,
      eucData.maxTemperature
    );

    TimeDate.setColor(Graphics.COLOR_WHITE);
    SpeedNumber.setColor(Graphics.COLOR_WHITE);
    BatteryNumber.setColor(Graphics.COLOR_WHITE);
    TemperatureNumber.setColor(Graphics.COLOR_WHITE);
    BottomSubtitle.setColor(Graphics.COLOR_WHITE);

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  function diplayStats() {
    //System.println(EUCAlarms.alarmType);
    var rideStatsText = "";
    if (!eucData.paired) {
      rideStatsText = "EUC Not\nConnected";
    } else {
      if (!EUCAlarms.alarmType.equals("none")) {
        rideStatsText = "!! Alarm: " + EUCAlarms.alarmType + " !!";
      } else {
        if (
          rideStats.statsArray != null &&
          rideStats.statsNumberToDiplay != 0
        ) {
          rideStatsText = rideStats.statsArray[rideStats.statsIndexToDiplay];

          rideStats.statsTimer--;
          if (rideStats.statsTimer < 0) {
            rideStats.statsIndexToDiplay++;
            rideStats.statsTimerReset();
            if (
              rideStats.statsIndexToDiplay >
              rideStats.statsNumberToDiplay - 1
            ) {
              rideStats.statsIndexToDiplay = 0;
            }
          }
        }
      }
    }
    //Sanity check, may return null during app initialization
    if (rideStatsText != null) {
      return rideStatsText;
    } else {
      return "";
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}
}
