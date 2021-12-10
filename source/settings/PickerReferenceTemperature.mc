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
using Toybox.WatchUi as Ui;

class PickerReferenceTemperature extends PickerGenericTemperature {

  //
  // FUNCTIONS: PickerGenericTemperature (override/implement)
  //

  function initialize() {
    PickerGenericTemperature.initialize(Ui.loadResource(Rez.Strings.titleReferenceTemperature) as String,
                                        $.oMyAltimeter.fTemperatureActual,
                                        $.oMySettings.iUnitTemperature,
                                        true);
  }

}

class PickerReferenceTemperatureDelegate extends Ui.PickerDelegate {

  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(_amValues) {
    // Set property and exit
    var fValue = PickerGenericTemperature.getValue(_amValues, $.oMySettings.iUnitTemperature);
    if($.oMyAltimeter.fTemperatureISA != null) {
      fValue -= ($.oMyAltimeter.fTemperatureISA as Float);
    }
    App.Properties.setValue("userReferenceTemperatureISAOffset", fValue as App.PropertyValueType);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
