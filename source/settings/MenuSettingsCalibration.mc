// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018-2021 Cedric Dufour <http://cedric.dufour.name>
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is free software:
// you can redistribute it and/or modify it under the terms of the GNU Calibration
// Public License as published by the Free Software Foundation, Version 3.
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU Calibration Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuSettingsCalibration extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsCalibration) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleCalibrationQNH) as String, :menuCalibrationQNH);
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
      Menu.addItem(Ui.loadResource(Rez.Strings.titleCalibrationElevation) as String, :menuCalibrationElevation);
    }
  }

}

class MenuSettingsCalibrationDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuCalibrationQNH) {
      //Sys.println("DEBUG: MenuSettingsCalibrationDelegate.onMenuItem(:menuCalibrationQNH)");
      Ui.pushView(new PickerCalibrationQNH(),
                  new PickerCalibrationQNHDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuCalibrationElevation) {
      //Sys.println("DEBUG: MenuSettingsCalibrationDelegate.onMenuItem(:menuCalibrationElevation)");
      Ui.pushView(new PickerCalibrationElevation(),
                  new PickerCalibrationElevationDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
