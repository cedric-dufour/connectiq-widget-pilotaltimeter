// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018 Cedric Dufour <http://cedric.dufour.name>
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
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Current view index and labels
var iMyViewIndex as Number = 0;
var sMyViewLabelTop as String?;
var sMyViewLabelBottom as String?;


//
// CLASS
//

class MyView extends Ui.View {

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

  // Resources
  // ... drawable
  private var oRezDrawable as MyDrawable?;
  // ... header
  private var oRezValueDate as Ui.Text?;
  // ... label
  private var oRezLabelTop as Ui.Text?;
  // ... fields
  private var oRezValueTop as Ui.Text?;
  private var oRezValueBottom as Ui.Text?;
  // ... label
  private var oRezLabelBottom as Ui.Text?;
  // ... footer
  private var oRezValueTime as Ui.Text?;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();
  }

  function onLayout(_oDC) {
    View.setLayout(Rez.Layouts.MyLayout(_oDC));

    // Load resources
    // ... drawable
    self.oRezDrawable = View.findDrawableById("MyDrawable") as MyDrawable?;
    // ... header
    self.oRezValueDate = View.findDrawableById("valueDate") as Ui.Text?;
    // ... label
    self.oRezLabelTop = View.findDrawableById("labelTop") as Ui.Text?;
    // ... fields
    self.oRezValueTop = View.findDrawableById("valueTop") as Ui.Text?;
    self.oRezValueBottom = View.findDrawableById("valueBottom") as Ui.Text?;
    // ... label
    self.oRezLabelBottom = View.findDrawableById("labelBottom") as Ui.Text?;
    // ... footer
    self.oRezValueTime = View.findDrawableById("valueTime") as Ui.Text?;
  }

  function onShow() {
    //Sys.println("DEBUG: MyView.onShow()");

    // Reload settings (which may have been changed by user)
    self.reloadSettings();

    // Set colors
    var iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    // ... background
    if(self.oRezDrawable != null) {
      (self.oRezDrawable as MyDrawable).setColorBackground($.oMySettings.iGeneralBackgroundColor);
    }
    // ... date
    if(self.oRezValueDate != null) {
      (self.oRezValueDate as Ui.Text).setColor(iColorText);
    }
    // ... fields
    if(self.oRezValueTop != null) {
      (self.oRezValueTop as Ui.Text).setColor(iColorText);
    }
    if(self.oRezValueBottom != null) {
      (self.oRezValueBottom as Ui.Text).setColor(iColorText);
    }
    // ... time
    if(self.oRezValueTime != null) {
      (self.oRezValueTime as Ui.Text).setColor(iColorText);
    }

    // Done
    self.bShow = true;
    $.oMyView = self;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyView.onUpdate()");

    // Update layout
    self.updateLayout();
    View.onUpdate(_oDC);
  }

  function onHide() {
    //Sys.println("DEBUG: MyView.onHide()");
    $.oMyView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function reloadSettings() as Void {
    //Sys.println("DEBUG: MyView.reloadSettings()");

    // Update application state
    (App.getApp() as MyApp).updateApp();
  }

  function updateUi() as Void {
    //Sys.println("DEBUG: MyView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function updateLayout() as Void {
    //Sys.println("DEBUG: MyView.updateLayout()");

    // Set header/footer values
    var iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    var oTimeNow = Time.now();

    // ... date
    if(self.oRezValueDate != null) {
      var oDateInfo = $.oMySettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_MEDIUM) : Gregorian.info(oTimeNow, Time.FORMAT_MEDIUM);
      (self.oRezValueDate as Ui.Text).setText(format("$1$ $2$", [oDateInfo.month, oDateInfo.day.format("%d")]));
    }

    // ... time
    if(self.oRezValueTime != null) {
      var oTimeInfo = $.oMySettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
      (self.oRezValueTime as Ui.Text).setText(format("$1$:$2$ $3$", [oTimeInfo.hour.format("%d"), oTimeInfo.min.format("%02d"), $.oMySettings.sUnitTime]));
    }

    // Set field values
    if($.iMyViewIndex == 0) {
      // ... actual altitude
      if(self.oRezLabelTop != null) {
        if($.sMyViewLabelTop == null) {
          $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeActual) as String;
        }
        (self.oRezLabelTop as Ui.Text).setText($.sMyViewLabelTop as String);
        if($.oMyAltimeter.fAltitudeActual != null) {
          (self.oRezValueTop as Ui.Text).setText(self.stringElevation($.oMyAltimeter.fAltitudeActual as Float, false));
        }
        else {
          (self.oRezValueTop as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
      // ... QNH
      if(self.oRezLabelBottom != null) {
        if($.sMyViewLabelBottom == null) {
          $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelPressureQNH) as String;
        }
        (self.oRezLabelBottom as Ui.Text).setText($.sMyViewLabelBottom as String);
        if($.oMyAltimeter.fQNH != null) {
          (self.oRezValueBottom as Ui.Text).setText(self.stringPressure($.oMyAltimeter.fQNH));
        }
        else {
          (self.oRezValueBottom as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
    }
    else if($.iMyViewIndex == 1) {
      // ... flight level
      if(self.oRezLabelTop != null) {
        if($.sMyViewLabelTop == null) {
          $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeFL) as String;
        }
        (self.oRezLabelTop as Ui.Text).setText($.sMyViewLabelTop as String);
        if($.oMyAltimeter.fAltitudeActual != null) {
          (self.oRezValueTop as Ui.Text).setText(self.stringFlightLevel($.oMyAltimeter.fAltitudeISA as Float, false));
        }
        else {
          (self.oRezValueTop as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
      // ... standard altitude (ISA)
      if(self.oRezLabelBottom != null) {
        if($.sMyViewLabelBottom == null) {
          $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelAltitudeISA) as String;
        }
        (self.oRezLabelBottom as Ui.Text).setText($.sMyViewLabelBottom as String);
        if($.oMyAltimeter.fAltitudeISA != null) {
          (self.oRezValueBottom as Ui.Text).setText(self.stringFlightLevel($.oMyAltimeter.fAltitudeISA as Float, true));
        }
        else {
          (self.oRezValueBottom as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
    }
    else if($.iMyViewIndex == 2) {
      // ... height
      if(self.oRezLabelTop != null) {
        if($.sMyViewLabelTop == null) {
          $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelHeight) as String;
        }
        (self.oRezLabelTop as Ui.Text).setText($.sMyViewLabelTop as String);
        if($.oMyAltimeter.fAltitudeActual != null and $.oMySettings.fReferenceElevation != null) {
          (self.oRezValueTop as Ui.Text).setText(self.stringElevation(($.oMyAltimeter.fAltitudeActual as Float)-$.oMySettings.fReferenceElevation, true));
        }
        else {
          (self.oRezValueTop as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
      // ... reference elevation
      if(self.oRezLabelBottom != null) {
        if($.sMyViewLabelBottom == null) {
          $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelElevation) as String;
        }
        (self.oRezLabelBottom as Ui.Text).setText($.sMyViewLabelBottom as String);
        if($.oMySettings.fReferenceElevation != null) {
          (self.oRezValueBottom as Ui.Text).setText(self.stringElevation($.oMySettings.fReferenceElevation, false));
        }
        else {
          (self.oRezValueBottom as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
    }
    else if($.iMyViewIndex == 3) {
      // ... density altitude
      if(self.oRezLabelTop != null) {
        if($.sMyViewLabelTop == null) {
          $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeDensity) as String;
        }
        (self.oRezLabelTop as Ui.Text).setText($.sMyViewLabelTop as String);
        if($.oMyAltimeter.fAltitudeDensity != null) {
          (self.oRezValueTop as Ui.Text).setText(self.stringElevation($.oMyAltimeter.fAltitudeDensity as Float, false));
        }
        else {
          (self.oRezValueTop as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
      // ... temperature
      if(self.oRezLabelBottom != null) {
        if($.sMyViewLabelBottom == null) {
          $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelTemperature) as String;
        }
        (self.oRezLabelBottom as Ui.Text).setText($.sMyViewLabelBottom as String);
        if($.oMyAltimeter.fTemperatureISA != null and $.oMyAltimeter.fTemperatureActual != null) {
          (self.oRezValueBottom as Ui.Text).setText(format("$1$ / ISA$2$", [self.stringTemperature($.oMyAltimeter.fTemperatureActual as Float, false),
                                                                            self.stringTemperature(($.oMyAltimeter.fTemperatureActual as Float)-($.oMyAltimeter.fTemperatureISA as Float), true)]));
        }
        else {
          (self.oRezValueBottom as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
    }
    else if($.iMyViewIndex == 4) {
      // ... QFE (calibrated)
      if(self.oRezLabelTop != null) {
        if($.sMyViewLabelTop == null) {
          $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelPressureQFE) as String;
        }
        (self.oRezLabelTop as Ui.Text).setText($.sMyViewLabelTop as String);
        if($.oMyAltimeter.fQFE != null) {
          (self.oRezValueTop as Ui.Text).setText(self.stringPressure($.oMyAltimeter.fQFE as Float));
        }
        else {
          (self.oRezValueTop as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
      // ... temperature
      if(self.oRezLabelBottom != null) {
        if($.sMyViewLabelBottom == null) {
          $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelPressureQFERaw) as String;
        }
        (self.oRezLabelBottom as Ui.Text).setText($.sMyViewLabelBottom as String);
        if($.oMyAltimeter.fQFE_raw != null) {
          (self.oRezValueBottom as Ui.Text).setText(self.stringPressure($.oMyAltimeter.fQFE_raw as Float));
        }
        else {
          (self.oRezValueBottom as Ui.Text).setText(self.NOVALUE_LEN3);
        }
      }
    }
  }

  function stringElevation(_fElevation as Float, _bDelta as Boolean) as String {
    var fValue = _fElevation * $.oMySettings.fUnitElevationCoefficient;
    var sValue = _bDelta ? fValue.format("%+.0f") : fValue.format("%.0f");
    return format("$1$ $2$", [sValue, $.oMySettings.sUnitElevation]);
  }

  function stringFlightLevel(_fElevation as Float, _bAsFeet as Boolean) as String {
    var fValue = _fElevation * 3.280839895f;
    if(_bAsFeet) {
      return format("$1$ ft", [fValue.format("%.0f")]);
    }
    else {
      var fValue2 = Math.round(fValue/500.0f)*5.0f;  // [FL]
      var sSign = "";
      if(fValue-100.0f*fValue2 > 100.0f) {
        sSign = "+";
      }
      if(fValue-100.0f*fValue2 < -100.0f) {
        sSign = "-";
      }
      return format("FL$1$$2$", [fValue2.format("%.0f"), sSign]);
    }
  }

  function stringPressure(_fPressure as Float) as String {
    var fValue = _fPressure * $.oMySettings.fUnitPressureCoefficient;
    var sValue = fValue < 100.0f ? fValue.format("%.3f") : fValue.format("%.1f");
    return format("$1$ $2$", [sValue, $.oMySettings.sUnitPressure]);
  }

  function stringTemperature(_fTemperature as Float, _bDelta as Boolean) as String {
    var fValue = _fTemperature * $.oMySettings.fUnitTemperatureCoefficient;
    if(!_bDelta) {
      fValue += $.oMySettings.fUnitTemperatureOffset;
    }
    var sValue = _bDelta ? fValue.format("%+.1f") : fValue.format("%.1f");
    return format("$1$°$2$", [sValue, $.oMySettings.sUnitTemperature]);
  }

}

class MyViewDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewDelegate.onMenu()");
    Ui.pushView(new MenuSettings(), new MenuSettingsDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: MyViewDelegate.onSelect()");
    $.iMyViewIndex = ( $.iMyViewIndex + 1 ) % 5;
    $.sMyViewLabelTop = null;
    $.sMyViewLabelBottom = null;
    Ui.requestUpdate();
    return true;
  }

}
