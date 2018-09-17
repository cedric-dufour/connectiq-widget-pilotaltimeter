// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (Pilot Altimeter)
// Copyright (C) 2018 Cedric Dufour <http://cedric.dufour.name>
//
// Pilot ICAO/ISA Altimeter (Pilot Altimeter) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Pilot ICAO/ISA Altimeter (Pilot Altimeter) is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuSettingsGeneral extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsGeneral));
    Menu.addItem(Ui.loadResource(Rez.Strings.titleGeneralTimeConstant), :menuGeneralTimeConstant);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor), :menuGeneralBackgroundColor);
  }

}

class MenuDelegateSettingsGeneral extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuGeneralTimeConstant) {
      //Sys.println("DEBUG: MenuDelegateSettingsGeneral.onMenuItem(:menuGeneralTimeConstant)");
      Ui.pushView(new PickerGeneralTimeConstant(), new PickerDelegateGeneralTimeConstant(), Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuGeneralBackgroundColor) {
      //Sys.println("DEBUG: MenuDelegateSettingsGeneral.onMenuItem(:menuGeneralBackgroundColor)");
      Ui.pushView(new PickerGeneralBackgroundColor(), new PickerDelegateGeneralBackgroundColor(), Ui.SLIDE_IMMEDIATE);
    }
  }

}
