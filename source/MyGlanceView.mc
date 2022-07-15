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

  private const NOVALUE_LEN2 = "--";
  private const NOVALUE_LEN3 = "---";


  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow as Boolean = false;

  // Layout
  private var iXCenter as Number = 0;
  private var iXLeft as Number = 0;
  private var iYLine2 as Number = 0;
  private var iYLine3 as Number = 0;


  //
  // FUNCTIONS: Ui.GlanceView (override/implement)
  //

  function initialize() {
    GlanceView.initialize();
  }


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function onLayout(_oDC) {
    // Layout
    self.iXCenter = (0.50*_oDC.getWidth()).toNumber();
    self.iXLeft = _oDC.getWidth();
    self.iYLine2 = (0.25*_oDC.getHeight()).toNumber();
    self.iYLine3 = (0.67*_oDC.getHeight()).toNumber();
  }

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

    // Values (line 2)
    var fValue, sValue;
    _oDC.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

    // ... actual altitude
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = format("$1$$2$", [fValue.format("%.0f"), $.oMySettings.sUnitElevation]);
    }
    else {
      sValue = self.NOVALUE_LEN3;
    }
    _oDC.drawText(0, self.iYLine2, Gfx.FONT_SYSTEM_SMALL, sValue, Gfx.TEXT_JUSTIFY_LEFT);

    // ... flight level
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeISA)) {
      fValue = Math.round($.oMyAltimeter.fAltitudeISA*0.00656167979f)*5.0f;  // [FL]
      sValue = format("FL$1$", [fValue.format("%.0f")]);
    }
    else {
      sValue = self.NOVALUE_LEN3;
    }
    _oDC.drawText(self.iXLeft, self.iYLine2, Gfx.FONT_SYSTEM_SMALL, sValue, Gfx.TEXT_JUSTIFY_RIGHT);

    // Values (secondary, line 3)
    _oDC.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);

    // ... QNH
    if(LangUtils.notNaN($.oMyAltimeter.fQNH)) {
      fValue = $.oMyAltimeter.fQNH * $.oMySettings.fUnitPressureCoefficient;
      sValue = format("$1$$2$",[fValue < 100.0f ? fValue.format("%.2f") : fValue.format("%.0f"), $.oMySettings.sUnitPressure]);
    }
    else {
      sValue = self.NOVALUE_LEN2;
    }
    _oDC.drawText(0, self.iYLine3, Gfx.FONT_SYSTEM_XTINY, sValue, Gfx.TEXT_JUSTIFY_LEFT);

    // ... temperature
    if(LangUtils.notNaN($.oMyAltimeter.fTemperatureISA) and LangUtils.notNaN($.oMyAltimeter.fTemperatureActual)) {
      fValue = ($.oMyAltimeter.fTemperatureActual-$.oMyAltimeter.fTemperatureISA) * $.oMySettings.fUnitTemperatureCoefficient;
      sValue = format("$1$°$2$", [fValue.format("%+.0f"), $.oMySettings.sUnitTemperature]);
    }
    else {
      sValue = self.NOVALUE_LEN2;
    }
    _oDC.drawText(self.iXCenter, self.iYLine3, Gfx.FONT_SYSTEM_XTINY, sValue, Gfx.TEXT_JUSTIFY_CENTER);

    // ... density altitude
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeDensity)) {
      fValue = $.oMyAltimeter.fAltitudeDensity * $.oMySettings.fUnitElevationCoefficient;
      sValue = format("$1$$2$", [fValue.format("%.0f"), $.oMySettings.sUnitElevation]);
    }
    else {
      sValue = self.NOVALUE_LEN2;
    }
    _oDC.drawText(self.iXLeft, self.iYLine3, Gfx.FONT_SYSTEM_XTINY, sValue, Gfx.TEXT_JUSTIFY_RIGHT);
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
