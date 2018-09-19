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

using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class PA_Drawable extends Ui.Drawable {

  //
  // VARIABLES
  //

  // Background color
  private var iColorBackground;


  //
  // FUNCTIONS: Ui.Drawable (override/implement)
  //

  function initialize() {
    Drawable.initialize({ :identifier => "PA_Drawable" });

    // Background color
    self.iColorBackground = Gfx.COLOR_BLACK;
  }

  function draw(_oDC) {
    // Draw

    // ... background
    _oDC.setColor(self.iColorBackground, self.iColorBackground);
    _oDC.clear();
  }


  //
  // FUNCTIONS: self
  //

  function setColorBackground(_iColorBackground) {
    self.iColorBackground = _iColorBackground;
  }

}
