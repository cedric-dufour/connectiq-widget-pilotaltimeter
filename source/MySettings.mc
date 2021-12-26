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
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

(:glance)
class MySettings {

  //
  // VARIABLES
  //

  // Settings
  // ... calibration
  public var fCalibrationQNH as Float = 1013.25f;
  // ... reference
  public var fReferenceElevation as Float = 0.0f;
  public var fReferenceTemperatureISAOffset as Float = 0.0f;
  public var bReferenceTemperatureAuto as Boolean = false;
  // ... general
  public var iGeneralBackgroundColor as Number = 0;
  // ... units
  public var iUnitElevation as Number = -1;
  public var iUnitPressure as Number = -1;
  public var iUnitTemperature as Number = -1;
  public var bUnitTimeUTC as Boolean = false;
  // ... correction
  public var fCorrectionAbsolute as Float = 0.0f;
  public var fCorrectionRelative as Float = 1.0f;

  // Units
  // ... symbols
  public var sUnitElevation as String = "m";
  public var sUnitPressure as String = "mb";
  public var sUnitTemperature as String = "C";
  public var sUnitTime as String = "LT";
  // ... conversion coefficients/offsets
  public var fUnitElevationCoefficient as Float = 1.0f;
  public var fUnitPressureCoefficient as Float = 0.01f;
  public var fUnitTemperatureCoefficient as Float = 1.0f;
  public var fUnitTemperatureOffset as Float = -273.15f;


  //
  // FUNCTIONS: self
  //

  function load() as Void {
    // Settings
    // ... calibration
    self.setCalibrationQNH(App.Properties.getValue("userCalibrationQNH") as Float?);
    // ... reference
    self.setReferenceElevation(App.Properties.getValue("userReferenceElevation") as Float?);
    self.setReferenceTemperatureISAOffset(App.Properties.getValue("userReferenceTemperatureISAOffset") as Float?);
    self.setReferenceTemperatureAuto(App.Properties.getValue("userReferenceTemperatureAuto") as Boolean?);
    // ... general
    self.setGeneralBackgroundColor(App.Properties.getValue("userGeneralBackgroundColor") as Number?);
    // ... units
    self.setUnitElevation(App.Properties.getValue("userUnitElevation") as Number?);
    self.setUnitPressure(App.Properties.getValue("userUnitPressure") as Number?);
    self.setUnitTemperature(App.Properties.getValue("userUnitTemperature") as Number?);
    self.setUnitTimeUTC(App.Properties.getValue("userUnitTimeUTC") as Boolean?);
    // ... correction
    self.setCorrectionAbsolute(App.Properties.getValue("userCorrectionAbsolute") as Float?);
    self.setCorrectionRelative(App.Properties.getValue("userCorrectionRelative") as Float?);
  }

  function setCalibrationQNH(_fValue as Float?) as Void {  // [Pa]
    // REF: https://en.wikipedia.org/wiki/Atmospheric_pressure#Records
    var fValue = _fValue != null ? _fValue : 101325.0f;
    if(fValue > 110000.0f) {
      fValue = 110000.0f;
    }
    else if(fValue < 85000.0f) {
      fValue = 85000.0f;
    }
    self.fCalibrationQNH = fValue;
  }

  function setReferenceElevation(_fValue as Float?) as Void {  // [m]
    var fValue = _fValue != null ? _fValue : 0.0f;
    if(fValue > 9999.0f) {
      fValue = 9999.0f;
    }
    else if(fValue < 0.0f) {
      fValue = 0.0f;
    }
    self.fReferenceElevation = fValue;
  }

  function setReferenceTemperatureISAOffset(_fValue as Float?) as Void {  // [°K]
    var fValue = _fValue != null ? _fValue : 0.0f;
    if(fValue > 99.9f) {
      fValue = 99.9f;
    }
    else if(fValue < -99.9f) {
      fValue = 99.9f;
    }
    self.fReferenceTemperatureISAOffset = fValue;
  }

  function setReferenceTemperatureAuto(_bValue as Boolean?) as Void {
    var bValue = _bValue != null ? _bValue : false;
    self.bReferenceTemperatureAuto = bValue;
  }

  function setGeneralBackgroundColor(_iValue as Number?) as Void {
    var iValue = _iValue != null ? _iValue : Gfx.COLOR_BLACK;
    self.iGeneralBackgroundColor = iValue;
  }

  function setUnitElevation(_iValue as Number?) as Void {
    var iValue = _iValue != null ? _iValue : -1;
    if(iValue < 0 or iValue > 1) {
      iValue = -1;
    }
    self.iUnitElevation = iValue;
    if(self.iUnitElevation < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
        iValue = oDeviceSettings.elevationUnits;
      }
      else {
        iValue = Sys.UNIT_METRIC;
      }
    }
    if(iValue == Sys.UNIT_STATUTE) {  // ... statute
      // ... [ft]
      self.sUnitElevation = "ft";
      self.fUnitElevationCoefficient = 3.280839895f;  // ... m -> ft
    }
    else {  // ... metric
      // ... [m]
      self.sUnitElevation = "m";
      self.fUnitElevationCoefficient = 1.0f;  // ... m -> m
    }
  }

  function setUnitPressure(_iValue as Number?) as Void {
    var iValue = _iValue != null ? _iValue : -1;
    if(iValue < 0 or iValue > 1) {
      iValue = -1;
    }
    self.iUnitPressure = iValue;
    if(self.iUnitPressure < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred pressure units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        iValue = oDeviceSettings.weightUnits;
      }
      else {
        iValue = Sys.UNIT_METRIC;
      }
    }
    if(iValue == Sys.UNIT_STATUTE) {  // ... statute
      // ... [inHg]
      self.sUnitPressure = "inHg";
      self.fUnitPressureCoefficient = 0.0002953f;  // ... Pa -> inHg
    }
    else {  // ... metric
      // ... [mb/hPa]
      self.sUnitPressure = "mb";
      self.fUnitPressureCoefficient = 0.01f;  // ... Pa -> mb/hPa
    }
  }

  function setUnitTemperature(_iValue as Number?) as Void {
    var iValue = _iValue != null ? _iValue : -1;
    if(iValue < 0 or iValue > 1) {
      iValue = -1;
    }
    self.iUnitTemperature = iValue;
    if(self.iUnitTemperature < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        iValue = oDeviceSettings.temperatureUnits;
      }
      else {
        iValue = Sys.UNIT_METRIC;
      }
    }
    if(iValue == Sys.UNIT_STATUTE) {  // ... statute
      // ... [°F]
      self.sUnitTemperature = "F";
      self.fUnitTemperatureCoefficient = 1.8f;  // ... °K -> °F
      self.fUnitTemperatureOffset = -459.67f;
    }
    else {  // ... metric
      // ... [°C]
      self.sUnitTemperature = "C";
      self.fUnitTemperatureCoefficient = 1.0f;  // ... °K -> °C
      self.fUnitTemperatureOffset = -273.15f;
    }

  }

  function setUnitTimeUTC(_bValue as Boolean?) as Void {
    var bValue = _bValue != null ? _bValue : false;
    self.bUnitTimeUTC = bValue;
    if(bValue) {
      self.sUnitTime = "Z";
    }
    else {
      self.sUnitTime = "LT";
    }
  }

  function setCorrectionAbsolute(_fValue as Float?) as Void {  // [Pa]
    var fValue = _fValue != null ? _fValue : 101325.0f;
    if(fValue > 9999.0f) {
      fValue = 9999.0f;
    }
    else if(fValue < -9999.0f) {
      fValue = -9999.0f;
    }
    self.fCorrectionAbsolute = fValue;
  }

  function setCorrectionRelative(_fValue as Float?) as Void {
    var fValue = _fValue != null ? _fValue : 101325.0f;
    if(fValue > 1.9999f) {
      fValue = 1.9999f;
    }
    else if(fValue < 0.0001f) {
      fValue = 0.0001f;
    }
    self.fCorrectionRelative = fValue;
  }

}
