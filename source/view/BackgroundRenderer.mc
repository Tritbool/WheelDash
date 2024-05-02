import Toybox.WatchUi;
import Toybox.System;

class BackgroundRenderer extends WatchUi.Drawable {
  private var bg;
  function initialize(params) {
    Drawable.initialize(params);

    if (!eucData.limitedMemory) {
      bg = Application.loadResource(Rez.Drawables.BackgroundImg);
    }
  }

  function draw(dc) {
    var screenDiam = dc.getWidth();
    dc.setColor(0x000000, 0x000000);

    if (!eucData.limitedMemory) {
      dc.drawBitmap(0, 0, bg);
    } else {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.clear();
      // red zone
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
      dc.setPenWidth(9);
      dc.drawArc(
        screenDiam / 2,
        screenDiam / 2,
        0.47 * screenDiam,
        Graphics.ARC_CLOCKWISE,
        18,
        330
      );
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.setPenWidth(2);
      var startingAngle = 120;
      for (var majorTick = 0; majorTick < 11; majorTick++) {
        var startCoord = getXY(
          screenDiam,
          120,
          0.46 * screenDiam,
          24,
          majorTick
        );
        var endCoord = getXY(screenDiam, 120, 0.49 * screenDiam, 24, majorTick);
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var majorBtrTick = 0; majorBtrTick < 3; majorBtrTick++) {
        var startCoord = getXY(
          screenDiam,
          120,
          0.26 * screenDiam,
          36,
          majorBtrTick
        );
        var endCoord = getXY(
          screenDiam,
          120,
          0.29 * screenDiam,
          36,
          majorBtrTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var majorTempTick = 0; majorTempTick < 3; majorTempTick++) {
        var startCoord = getXY(
          screenDiam,
          312,
          0.26 * screenDiam,
          36,
          majorTempTick
        );
        var endCoord = getXY(
          screenDiam,
          312,
          0.29 * screenDiam,
          36,
          majorTempTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      dc.setPenWidth(1);
      for (var minorTick = 0; minorTick < 51; minorTick++) {
        var startCoord = getXY(
          screenDiam,
          120,
          0.46 * screenDiam,
          4.8,
          minorTick
        );
        var endCoord = getXY(
          screenDiam,
          120,
          0.49 * screenDiam,
          4.8,
          minorTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var minorBtrTick = 0; minorBtrTick < 5; minorBtrTick++) {
        var startCoord = getXY(
          screenDiam,
          120,
          0.28 * screenDiam,
          18,
          minorBtrTick
        );
        var endCoord = getXY(
          screenDiam,
          120,
          0.29 * screenDiam,
          18,
          minorBtrTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var minorTempTick = 0; minorTempTick < 5; minorTempTick++) {
        var startCoord = getXY(
          screenDiam,
          312,
          0.28 * screenDiam,
          18,
          minorTempTick
        );
        var endCoord = getXY(
          screenDiam,
          312,
          0.29 * screenDiam,
          18,
          minorTempTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
    }
  }
}
