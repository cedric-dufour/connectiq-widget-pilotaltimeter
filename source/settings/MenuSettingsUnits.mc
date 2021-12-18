// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018-2021 Cedric Dufour <http://cedric.dufour.name>
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
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuSettingsUnits extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitElevation) as String, :menuUnitElevation);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitPressure) as String, :menuUnitPressure);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTemperature) as String, :menuUnitTemperature);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTimeUTC) as String, :menuUnitTimeUTC);
  }

}

class MenuSettingsUnitsDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuUnitElevation) {
      //Sys.println("DEBUG: MenuSettingsUnitsDelegate.onMenuItem(:menuUnitElevation)");
      Ui.pushView(new PickerUnitElevation(),
                  new PickerUnitElevationDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuUnitPressure) {
      //Sys.println("DEBUG: MenuSettingsUnitsDelegate.onMenuItem(:menuUnitPressure)");
      Ui.pushView(new PickerUnitPressure(),
                  new PickerUnitPressureDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuUnitTemperature) {
      //Sys.println("DEBUG: MenuSettingsUnitsDelegate.onMenuItem(:menuUnitTemperature)");
      Ui.pushView(new PickerUnitTemperature(),
                  new PickerUnitTemperatureDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuUnitTimeUTC) {
      //Sys.println("DEBUG: MenuSettingsUnitsDelegate.onMenuItem(:menuUnitTimeUTC)");
      Ui.pushView(new PickerUnitTimeUTC(),
                  new PickerUnitTimeUTCDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
