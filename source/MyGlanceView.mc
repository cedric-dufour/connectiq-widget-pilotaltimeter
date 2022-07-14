// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;


//
// CLASS
//

(:glance)
class MyGlanceView extends Ui.GlanceView {

  //
  // CONSTANTS
  //

  private const NOVALUE_BLANK = "";
  private const NOVALUE_LEN3 = "---";


  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow as Boolean = false;


  //
  // FUNCTIONS: Ui.GlanceView (override/implement)
  //

  function initialize() {
    GlanceView.initialize();
  }


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function onShow() {
    //Sys.println("DEBUG: MyGlanceView.onShow()");

    // Update application state
    (App.getApp() as MyApp).updateApp();

    // Done
    self.bShow = true;
    $.oMyGlanceView = self;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyGlanceView.onUpdate()");
    GlanceView.onUpdate(_oDC);

    // Label
    _oDC.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
    _oDC.drawText(0, 0, Gfx.FONT_GLANCE, "PILOT ALTIMETER", Gfx.TEXT_JUSTIFY_LEFT);

    // Values
    var fValue, sValue;

    // ... actual altitude
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = format("$1$ $2$", [fValue.format("%.0f"), $.oMySettings.sUnitElevation]);
    }
    else {
      sValue = self.NOVALUE_LEN3;
    }
    _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    _oDC.drawText(0, 0.25*_oDC.getHeight(), Gfx.FONT_SYSTEM_SMALL, sValue, Gfx.TEXT_JUSTIFY_LEFT);

    // ... QNH
    if(LangUtils.notNaN($.oMyAltimeter.fQNH)) {
      fValue = $.oMyAltimeter.fQNH * $.oMySettings.fUnitPressureCoefficient;
      sValue = format("$1$ $2$",[fValue < 100.0f ? fValue.format("%.3f") : fValue.format("%.1f"), $.oMySettings.sUnitPressure]);
    }
    else {
      sValue = self.NOVALUE_BLANK;
    }
    _oDC.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
    _oDC.drawText(0, 0.67*_oDC.getHeight(), Gfx.FONT_SYSTEM_XTINY, sValue, Gfx.TEXT_JUSTIFY_LEFT);
  }

  function onHide() {
    //Sys.println("DEBUG: MyGlanceView.onHide()");
    $.oMyGlanceView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function updateUi() as Void {
    //Sys.println("DEBUG: MyGlanceView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

}

(:glance)
class MyGlanceViewDelegate extends Ui.GlanceViewDelegate {

  function initialize() {
    GlanceViewDelegate.initialize();
  }

}
