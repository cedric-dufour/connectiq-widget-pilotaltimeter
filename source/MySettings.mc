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
    self.setCalibrationQNH(self.loadCalibrationQNH());
    // ... reference
    self.setReferenceElevation(self.loadReferenceElevation());
    self.setReferenceTemperatureISAOffset(self.loadReferenceTemperatureISAOffset());
    self.setReferenceTemperatureAuto(self.loadReferenceTemperatureAuto());
    // ... general
    self.setGeneralBackgroundColor(self.loadGeneralBackgroundColor());
    // ... units
    self.setUnitElevation(self.loadUnitElevation());
    self.setUnitPressure(self.loadUnitPressure());
    self.setUnitTemperature(self.loadUnitTemperature());
    self.setUnitTimeUTC(self.loadUnitTimeUTC());
    // ... correction
    self.setCorrectionAbsolute(self.loadCorrectionAbsolute());
    self.setCorrectionRelative(self.loadCorrectionRelative());
  }

  function loadCalibrationQNH() as Float {  // [Pa]
    var fValue = App.Properties.getValue("userCalibrationQNH") as Float?;
    return fValue != null ? fValue : 101325.0f;
  }
  function saveCalibrationQNH(_fValue as Float) as Void {  // [Pa]
    App.Properties.setValue("userCalibrationQNH", _fValue as App.PropertyValueType);
  }
  function setCalibrationQNH(_fValue as Float) as Void {  // [Pa]
    // REF: https://en.wikipedia.org/wiki/Atmospheric_pressure#Records
    if(_fValue > 110000.0f) {
      _fValue = 110000.0f;
    }
    else if(_fValue < 85000.0f) {
      _fValue = 85000.0f;
    }
    self.fCalibrationQNH = _fValue;
  }

  function loadReferenceElevation() as Float {  // [m]
    var fValue = App.Properties.getValue("userReferenceElevation") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveReferenceElevation(_fValue as Float) as Void {  // [m]
    App.Properties.setValue("userReferenceElevation", _fValue as App.PropertyValueType);
  }
  function setReferenceElevation(_fValue as Float) as Void {  // [m]
    if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fReferenceElevation = _fValue;
  }

  function loadReferenceTemperatureISAOffset() as Float {  // [°K]
    var fValue = App.Properties.getValue("userReferenceTemperatureISAOffset") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveReferenceTemperatureISAOffset(_fValue as Float) as Void {  // [°K]
    App.Properties.setValue("userReferenceTemperatureISAOffset", _fValue as App.PropertyValueType);
  }
  function setReferenceTemperatureISAOffset(_fValue as Float) as Void {  // [°K]
    if(_fValue > 99.9f) {
      _fValue = 99.9f;
    }
    else if(_fValue < -99.9f) {
      _fValue = 99.9f;
    }
    self.fReferenceTemperatureISAOffset = _fValue;
  }

  function loadReferenceTemperatureAuto() as Boolean {
    var bValue = App.Properties.getValue("userReferenceTemperatureAuto") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveReferenceTemperatureAuto(_bValue as Boolean) as Void {
    App.Properties.setValue("userReferenceTemperatureAuto", _bValue as App.PropertyValueType);
  }
  function setReferenceTemperatureAuto(_bValue as Boolean) as Void {
    self.bReferenceTemperatureAuto = _bValue;
  }

  function loadGeneralBackgroundColor() as Number {
    var iValue = App.Properties.getValue("userGeneralBackgroundColor") as Number?;
    return iValue != null ? iValue : Gfx.COLOR_BLACK;
  }
  function saveGeneralBackgroundColor(_iValue as Number) as Void {
    App.Properties.setValue("userGeneralBackgroundColor", _iValue as App.PropertyValueType);
  }
  function setGeneralBackgroundColor(_iValue as Number) as Void {
    self.iGeneralBackgroundColor = _iValue;
  }

  function loadUnitElevation() as Number {
    var iValue = App.Properties.getValue("userUnitElevation") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitElevation(_iValue as Number) as Void {
    App.Properties.setValue("userUnitElevation", _iValue as App.PropertyValueType);
  }
  function setUnitElevation(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitElevation = _iValue;
    if(self.iUnitElevation < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
        _iValue = oDeviceSettings.elevationUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitPressure() as Number {
    var iValue = App.Properties.getValue("userUnitPressure") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitPressure(_iValue as Number) as Void {
    App.Properties.setValue("userUnitPressure", _iValue as App.PropertyValueType);
  }
  function setUnitPressure(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitPressure = _iValue;
    if(self.iUnitPressure < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred pressure units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iValue = oDeviceSettings.weightUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitTemperature() as Number {
    var iValue = App.Properties.getValue("userUnitTemperature") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitTemperature(_iValue as Number) as Void {
    App.Properties.setValue("userUnitTemperature", _iValue as App.PropertyValueType);
  }
  function setUnitTemperature(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitTemperature = _iValue;
    if(self.iUnitTemperature < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        _iValue = oDeviceSettings.temperatureUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitTimeUTC() as Boolean {
    var bValue = App.Properties.getValue("userUnitTimeUTC") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveUnitTimeUTC(_bValue as Boolean) as Void {
    App.Properties.setValue("userUnitTimeUTC", _bValue as App.PropertyValueType);
  }
  function setUnitTimeUTC(_bValue as Boolean) as Void {
    self.bUnitTimeUTC = _bValue;
    if(_bValue) {
      self.sUnitTime = "Z";
    }
    else {
      self.sUnitTime = "LT";
    }
  }

  function loadCorrectionAbsolute() as Float {  // [Pa]
    var fValue = App.Properties.getValue("userCorrectionAbsolute") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveCorrectionAbsolute(_fValue as Float) as Void {
    App.Properties.setValue("userCorrectionAbsolute", _fValue as App.PropertyValueType);
  }
  function setCorrectionAbsolute(_fValue as Float) as Void {  // [Pa]
    if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < -9999.0f) {
      _fValue = -9999.0f;
    }
    self.fCorrectionAbsolute = _fValue;
  }

  function loadCorrectionRelative() as Float {
    var fValue = App.Properties.getValue("userCorrectionRelative") as Float?;
    return fValue != null ? fValue : 1.0f;
  }
  function saveCorrectionRelative(_fValue as Float) as Void {
    App.Properties.setValue("userCorrectionRelative", _fValue as App.PropertyValueType);
  }
  function setCorrectionRelative(_fValue as Float) as Void {
    if(_fValue > 1.9999f) {
      _fValue = 1.9999f;
    }
    else if(_fValue < 0.0001f) {
      _fValue = 0.0001f;
    }
    self.fCorrectionRelative = _fValue;
  }

}
