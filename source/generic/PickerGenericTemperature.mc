// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Generic ConnectIQ Helpers/Resources (CIQ Helpers)
// Copyright (C) 2017-2021 Cedric Dufour <http://cedric.dufour.name>
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class PickerGenericTemperature extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_sTitle as String, _fValue as Float?, _iUnit as Number?, _bAllowNegative as Boolean) {
    // Input validation
    // ... unit
    var iUnit = _iUnit != null ? _iUnit : -1;
    if(iUnit < 0) {
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        iUnit = oDeviceSettings.temperatureUnits;
      }
      else {
        iUnit = Sys.UNIT_METRIC;
      }
    }
    // ... value
    var fValue = (_fValue != null and LangUtils.notNaN(_fValue)) ? _fValue : 0.0f;

    // Use user-specified temperature unit (NB: SI units are always used internally)
    // PRECISION: 0.1 (* 10)
    var sUnit = "°C";
    var iMaxSignificant = 9;
    if(iUnit == Sys.UNIT_STATUTE) {
      sUnit = "°F";
      iMaxSignificant = 19;
      fValue = (fValue-273.15f)*18.0f+320.0f;  // °K -> °F (* 10)
      if(fValue > 1999.0f) {
        fValue = 1999.0f;
      }
      else if(fValue < -1999.0f) {
        fValue = -1999.0f;
      }
    }
    else {
      fValue = (fValue-273.15f)*10.0f;  // °K -> °C (* 10)
      if(fValue > 999.0f) {
        fValue = 999.0f;
      }
      else if(fValue < -999.0f) {
        fValue = -999.0f;
      }
    }
    if(!_bAllowNegative and fValue < 0.0f) {
      fValue = 0.0f;
    }

    // Split components
    var aiValues = new Array<Number>[4];
    aiValues[0] = fValue < 0.0f ? 0 : 1;
    fValue = fValue.abs() + 0.05f;
    aiValues[3] = fValue.toNumber() % 10;
    fValue = fValue / 10.0f;
    aiValues[2] = fValue.toNumber() % 10;
    fValue = fValue / 10.0f;
    aiValues[1] = fValue.toNumber();

    // Initialize picker
    Picker.initialize({
        :title => new Ui.Text({
            :text => format("$1$ [$2$]", [_sTitle, sUnit]),
            :font => Gfx.FONT_TINY,
            :locX=>Ui.LAYOUT_HALIGN_CENTER,
            :locY=>Ui.LAYOUT_VALIGN_BOTTOM,
            :color => Gfx.COLOR_BLUE}),
        :pattern => [new PickerFactoryDictionary([-1, 1], ["-", "+"], null),
                     new PickerFactoryNumber(0, iMaxSignificant, null),
                     new PickerFactoryNumber(0, 9, {:langFormat => "$1$."}),
                     new PickerFactoryNumber(0, 9, null)],
        :defaults => aiValues});
  }


  //
  // FUNCTIONS: self
  //

  function getValue(_amValues as Array, _iUnit as Number?) as Float {
    // Input validation
    // ... unit
    var iUnit = _iUnit != null ? _iUnit : -1;
    if(iUnit < 0) {
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        iUnit = oDeviceSettings.temperatureUnits;
      }
      else {
        iUnit = Sys.UNIT_METRIC;
      }
    }

    // Assemble components
    var fValue = _amValues[1]*100.0f + _amValues[2]*10.0f + _amValues[3];
    fValue *= _amValues[0];

    // Use user-specified temperature unit (NB: SI units are always used internally)
    if(iUnit == Sys.UNIT_STATUTE) {
      fValue = (fValue-320.0f)/18.0f+273.15f;  // °F (* 10) -> °K
    }
    else {
      fValue = fValue/10.0f+273.15f;  // °C (* 10) -> °K
    }

    // Return value
    return fValue;
  }
}
