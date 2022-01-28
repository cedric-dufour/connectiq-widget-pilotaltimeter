// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot ICAO/ISA Altimeter (PilotAltimeter)
// Copyright (C) 2018-2022 Cedric Dufour <http://cedric.dufour.name>
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
using Toybox.Activity;
using Toybox.Application as App;
using Toybox.Sensor;
using Toybox.System as Sys;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var oMySettings as MySettings = new MySettings();

// Altimeter data
var oMyAltimeter as MyAltimeter = new MyAltimeter();

// Current view
var oMyView as MyView?;


//
// CLASS
//

(:glance)
class MyApp extends App.AppBase {

  //
  // VARIABLES
  //

  // UI update time
  private var oUpdateTimer as Timer.Timer?;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
    //Sys.println("DEBUG: MyApp.onStart()");

    // Enable sensor events
    Sensor.setEnabledSensors([Sensor.SENSOR_TEMPERATURE] as Array<Sensor.SensorType>);
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Start UI update timer (every multiple of 60 seconds)
    // NOTE: Sensor events will normally preempt this timer every second
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%60;
    if(iUpdateTimerDelay > 0) {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 60000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: MyApp.onStop()");

    // Stop UI update timer
    if(self.oUpdateTimer != null) {
      (self.oUpdateTimer as Timer.Timer).stop();
      self.oUpdateTimer = null;
    }

    // Disable sensor events
    Sensor.setEnabledSensors([] as Array<Sensor.SensorType>);
    Sensor.enableSensorEvents(null);
  }

  function getInitialView() {
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyView(), new MyViewDelegate()] as Array<Ui.Views or Ui.InputDelegates>;
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    self.updateApp();
  }


  //
  // FUNCTIONS: self
  //

  function updateApp() as Void {
    //Sys.println("DEBUG: MyApp.updateApp()");

    // Load settings
    self.loadSettings();
    $.oMyAltimeter.importSettings();

    // Update UI
    self.updateUi();
  }

  function loadSettings() as Void {
    //Sys.println("DEBUG: MyApp.loadSettings()");

    // Load settings
    $.oMySettings.load();
  }

  function onSensorEvent(_oSensorInfo as Sensor.Info) as Void {
    //Sys.println("DEBUG: MyApp.onSensorEvent());

    // Process sensor data
    // ... temperature
    if($.oMySettings.bReferenceTemperatureAuto) {
      if(_oSensorInfo has :temperature and _oSensorInfo.temperature != null) {
        $.oMyAltimeter.setTemperatureActual((_oSensorInfo.temperature as Float)+273.15f);  // ... altimeter internals are °K
      }
    }
    else {
      $.oMyAltimeter.setTemperatureActual(null);
    }
    // ... pressure
    var oActivityInfo = Activity.getActivityInfo();  // ... we need *raw ambient* pressure
    if(oActivityInfo != null) {
      if(oActivityInfo has :ambientPressure and oActivityInfo.ambientPressure != null) {
        $.oMyAltimeter.setQFE(oActivityInfo.ambientPressure as Float);
      }
    }

    // UI update
    self.updateUi();
  }

  function onUpdateTimer_init() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 60000, true);
  }

  function onUpdateTimer() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer()");
    self.updateUi();
  }

  function updateUi() as Void {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Update UI
    if($.oMyView != null) {
      ($.oMyView as MyView).updateUi();
    }
  }

}
