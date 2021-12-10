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
var iMyViewIndex = 0;
var sMyViewLabelTop = null;
var sMyViewLabelBottom = null;


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
  private var bShow;

  // Resources
  // ... drawable
  private var oRezDrawable;
  // ... header
  private var oRezValueDate;
  // ... label
  private var oRezLabelTop;
  // ... fields
  private var oRezValueTop;
  private var oRezValueBottom;
  // ... label
  private var oRezLabelBottom;
  // ... footer
  private var oRezValueTime;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Display mode (internal)
    self.bShow = false;
  }

  function onLayout(_oDC) {
    View.setLayout(Rez.Layouts.MyLayout(_oDC));

    // Load resources
    // ... drawable
    self.oRezDrawable = View.findDrawableById("MyDrawable");
    // ... header
    self.oRezValueDate = View.findDrawableById("valueDate");
    // ... label
    self.oRezLabelTop = View.findDrawableById("labelTop");
    // ... fields
    self.oRezValueTop = View.findDrawableById("valueTop");
    self.oRezValueBottom = View.findDrawableById("valueBottom");
    // ... label
    self.oRezLabelBottom = View.findDrawableById("labelBottom");
    // ... footer
    self.oRezValueTime = View.findDrawableById("valueTime");

    // Done
    return true;
  }

  function onShow() {
    //Sys.println("DEBUG: MyView.onShow()");

    // Reload settings (which may have been changed by user)
    self.reloadSettings();

    // Set colors
    var iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    // ... background
    self.oRezDrawable.setColorBackground($.oMySettings.iGeneralBackgroundColor);
    // ... date
    self.oRezValueDate.setColor(iColorText);
    // ... fields
    self.oRezValueTop.setColor(iColorText);
    self.oRezValueBottom.setColor(iColorText);
    // ... time
    self.oRezValueTime.setColor(iColorText);

    // Done
    self.bShow = true;
    $.oMyView = self;
    return true;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyView.onUpdate()");

    // Update layout
    self.updateLayout();
    View.onUpdate(_oDC);

    // Done
    return true;
  }

  function onHide() {
    //Sys.println("DEBUG: MyView.onHide()");
    $.oMyView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function reloadSettings() {
    //Sys.println("DEBUG: MyView.reloadSettings()");

    // Update application state
    App.getApp().updateApp();
  }

  function updateUi() {
    //Sys.println("DEBUG: MyView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyView.updateLayout()");

    // Set header/footer values
    var iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    var oTimeNow = Time.now();

    // ... date
    var oDateInfo = $.oMySettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_MEDIUM) : Gregorian.info(oTimeNow, Time.FORMAT_MEDIUM);
    self.oRezValueDate.setText(Lang.format("$1$ $2$", [oDateInfo.month, oDateInfo.day.format("%d")]));

    // ... time
    var oTimeInfo = $.oMySettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
    self.oRezValueTime.setText(Lang.format("$1$:$2$ $3$", [oTimeInfo.hour.format("%d"), oTimeInfo.min.format("%02d"), $.oMySettings.sUnitTime]));

    // Set field values
    if($.iMyViewIndex == 0) {
      // ... actual altitude
      if($.sMyViewLabelTop == null) {
        $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeActual);
      }
      self.oRezLabelTop.setText($.sMyViewLabelTop);
      if($.oMyAltimeter.fAltitudeActual != null) {
        self.oRezValueTop.setText(self.stringElevation($.oMyAltimeter.fAltitudeActual, false));
      }
      else {
        self.oRezValueTop.setText(self.NOVALUE_LEN3);
      }
      // ... QNH
      if($.sMyViewLabelBottom == null) {
        $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelPressureQNH);
      }
      self.oRezLabelBottom.setText($.sMyViewLabelBottom);
      if($.oMyAltimeter.fQNH != null) {
        self.oRezValueBottom.setText(self.stringPressure($.oMyAltimeter.fQNH));
      }
      else {
        self.oRezValueBottom.setText(self.NOVALUE_LEN3);
      }
    }
    else if($.iMyViewIndex == 1) {
      // ... flight level
      if($.sMyViewLabelTop == null) {
        $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeFL);
      }
      self.oRezLabelTop.setText($.sMyViewLabelTop);
      if($.oMyAltimeter.fAltitudeActual != null) {
        self.oRezValueTop.setText(self.stringFlightLevel($.oMyAltimeter.fAltitudeISA, false));
      }
      else {
        self.oRezValueTop.setText(self.NOVALUE_LEN3);
      }
      // ... standard altitude (ISA)
      if($.sMyViewLabelBottom == null) {
        $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelAltitudeISA);
      }
      self.oRezLabelBottom.setText($.sMyViewLabelBottom);
      if($.oMyAltimeter.fAltitudeISA != null) {
        self.oRezValueBottom.setText(self.stringFlightLevel($.oMyAltimeter.fAltitudeISA, true));
      }
      else {
        self.oRezValueBottom.setText(self.NOVALUE_LEN3);
      }
    }
    else if($.iMyViewIndex == 2) {
      // ... height
      if($.sMyViewLabelTop == null) {
        $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelHeight);
      }
      self.oRezLabelTop.setText($.sMyViewLabelTop);
      if($.oMyAltimeter.fAltitudeActual != null and $.oMySettings.fReferenceElevation != null) {
        self.oRezValueTop.setText(self.stringElevation($.oMyAltimeter.fAltitudeActual-$.oMySettings.fReferenceElevation, true));
      }
      else {
        self.oRezValueTop.setText(self.NOVALUE_LEN3);
      }
      // ... reference elevation
      if($.sMyViewLabelBottom == null) {
        $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelElevation);
      }
      self.oRezLabelBottom.setText($.sMyViewLabelBottom);
      if($.oMySettings.fReferenceElevation != null) {
        self.oRezValueBottom.setText(self.stringElevation($.oMySettings.fReferenceElevation, false));
      }
      else {
        self.oRezValueBottom.setText(self.NOVALUE_LEN3);
      }
    }
    else if($.iMyViewIndex == 3) {
      // ... density altitude
      if($.sMyViewLabelTop == null) {
        $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelAltitudeDensity);
      }
      self.oRezLabelTop.setText($.sMyViewLabelTop);
      if($.oMyAltimeter.fAltitudeDensity != null) {
        self.oRezValueTop.setText(self.stringElevation($.oMyAltimeter.fAltitudeDensity, false));
      }
      else {
        self.oRezValueTop.setText(self.NOVALUE_LEN3);
      }
      // ... temperature
      if($.sMyViewLabelBottom == null) {
        $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelTemperature);
      }
      self.oRezLabelBottom.setText($.sMyViewLabelBottom);
      if($.oMyAltimeter.fTemperatureISA != null and $.oMyAltimeter.fTemperatureActual != null) {
        self.oRezValueBottom.setText(Lang.format("$1$ / ISA$2$", [self.stringTemperature($.oMyAltimeter.fTemperatureActual, false), self.stringTemperature($.oMyAltimeter.fTemperatureActual-$.oMyAltimeter.fTemperatureISA, true)]));
      }
      else {
        self.oRezValueBottom.setText(self.NOVALUE_LEN3);
      }
    }
    else if($.iMyViewIndex == 4) {
      // ... QFE (calibrated)
      if($.sMyViewLabelTop == null) {
        $.sMyViewLabelTop = Ui.loadResource(Rez.Strings.labelPressureQFE);
      }
      self.oRezLabelTop.setText($.sMyViewLabelTop);
      if($.oMyAltimeter.fQFE != null) {
        self.oRezValueTop.setText(self.stringPressure($.oMyAltimeter.fQFE));
      }
      else {
        self.oRezValueTop.setText(self.NOVALUE_LEN3);
      }
      // ... temperature
      if($.sMyViewLabelBottom == null) {
        $.sMyViewLabelBottom = Ui.loadResource(Rez.Strings.labelPressureQFERaw);
      }
      self.oRezLabelBottom.setText($.sMyViewLabelBottom);
      if($.oMyAltimeter.fQFE_raw != null) {
        self.oRezValueBottom.setText(self.stringPressure($.oMyAltimeter.fQFE_raw));
      }
      else {
        self.oRezValueBottom.setText(self.NOVALUE_LEN3);
      }
    }
  }

  function stringElevation(_fElevation, _bDelta) {
    var fValue = _fElevation * $.oMySettings.fUnitElevationCoefficient;
    var sValue = _bDelta ? fValue.format("%+.0f") : fValue.format("%.0f");
    return Lang.format("$1$ $2$", [sValue, $.oMySettings.sUnitElevation]);
  }

  function stringFlightLevel(_fElevation, _bAsFeet) {
    var fValue = _fElevation * 3.280839895f;
    if(_bAsFeet) {
      return Lang.format("$1$ ft", [fValue.format("%.0f")]);
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
      return Lang.format("FL$1$$2$", [fValue2.format("%.0f"), sSign]);
    }
  }

  function stringPressure(_fPressure) {
    var fValue = _fPressure * $.oMySettings.fUnitPressureCoefficient;
    var sValue = fValue < 100.0f ? fValue.format("%.3f") : fValue.format("%.1f");
    return Lang.format("$1$ $2$", [sValue, $.oMySettings.sUnitPressure]);
  }

  function stringTemperature(_fTemperature, _bDelta) {
    var fValue = _fTemperature * $.oMySettings.fUnitTemperatureCoefficient;
    if(!_bDelta) {
      fValue += $.oMySettings.fUnitTemperatureOffset;
    }
    var sValue = _bDelta ? fValue.format("%+.1f") : fValue.format("%.1f");
    return Lang.format("$1$°$2$", [sValue, $.oMySettings.sUnitTemperature]);
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
