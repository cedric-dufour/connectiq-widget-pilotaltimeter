// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is free software:
// you can redistribute it and/or modify it under the terms of the GNU Reference
// Public License as published by the Free Software Foundation, Version 3.
//
// Pilot ICAO/ISA Altimeter (PilotAltimeter) is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU Reference Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuSettingsReference extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsReference) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleReferenceElevation) as String, :menuReferenceElevation);
    if(LangUtils.notNaN($.oMyAltimeter.fQFE)) {
      Menu.addItem(Ui.loadResource(Rez.Strings.titleReferenceTemperature) as String, :menuReferenceTemperature);
    }
    Menu.addItem(Ui.loadResource(Rez.Strings.titleReferenceTemperatureAuto) as String, :menuReferenceTemperatureAuto);
  }

}

class MenuSettingsReferenceDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuReferenceElevation) {
      //Sys.println("DEBUG: MenuSettingsReferenceDelegate.onMenuItem(:menuReferenceElevation)");
      Ui.pushView(new PickerReferenceElevation(),
                  new PickerReferenceElevationDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuReferenceTemperature) {
      //Sys.println("DEBUG: MenuSettingsReferenceDelegate.onMenuItem(:menuReferenceTemperature)");
      Ui.pushView(new PickerReferenceTemperature(),
                  new PickerReferenceTemperatureDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuReferenceTemperatureAuto) {
      //Sys.println("DEBUG: MenuSettingsReferenceDelegate.onMenuItem(:menuReferenceTemperatureAuto)");
      Ui.pushView(new PickerReferenceTemperatureAuto(),
                  new PickerReferenceTemperatureAutoDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
