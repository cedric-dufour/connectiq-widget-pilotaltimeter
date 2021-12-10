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
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuSettings extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettings) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsCalibration) as String, :menuSettingsCalibration);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsReference) as String, :menuSettingsReference);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsGeneral) as String, :menuSettingsGeneral);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String, :menuSettingsUnits);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsCorrection) as String, :menuSettingsCorrection);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsAbout) as String, :menuSettingsAbout);
  }

}

class MenuSettingsDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuSettingsCalibration) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsCalibration)");
      Ui.pushView(new MenuSettingsCalibration(),
                  new MenuSettingsCalibrationDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsReference) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsReference)");
      Ui.pushView(new MenuSettingsReference(),
                  new MenuSettingsReferenceDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsGeneral) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsGeneral)");
      Ui.pushView(new MenuSettingsGeneral(),
                  new MenuSettingsGeneralDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsUnits) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsUnits)");
      Ui.pushView(new MenuSettingsUnits(),
                  new MenuSettingsUnitsDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsCorrection) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsCorrection)");
      Ui.pushView(new MenuSettingsCorrection(),
                  new MenuSettingsCorrectionDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuSettingsAbout) {
      //Sys.println("DEBUG: MenuSettingsDelegate.onMenuItem(:menuSettingsAbout)");
      Ui.pushView(new MenuSettingsAbout(),
                  new MenuSettingsAboutDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
