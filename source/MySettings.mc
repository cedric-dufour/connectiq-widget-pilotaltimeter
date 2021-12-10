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

using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class MySettings {

  //
  // VARIABLES
  //

  // Settings
  // ... calibration
  public var fCalibrationQNH;
  // ... reference
  public var fReferenceElevation;
  public var fReferenceTemperatureISAOffset;
  public var bReferenceTemperatureAuto;
  // ... general
  public var iGeneralBackgroundColor;
  // ... units
  public var iUnitElevation;
  public var iUnitPressure;
  public var iUnitTemperature;
  public var bUnitTimeUTC;
  // ... correction
  public var fCorrectionAbsolute;
  public var fCorrectionRelative;

  // Units
  // ... symbols
  public var sUnitElevation;
  public var sUnitPressure;
  public var sUnitTemperature;
  public var sUnitTime;
  // ... conversion coefficients/offsets
  public var fUnitElevationCoefficient;
  public var fUnitPressureCoefficient;
  public var fUnitTemperatureCoefficient;
  public var fUnitTemperatureOffset;


  //
  // FUNCTIONS: self
  //

  function load() {
    // Settings
    // ... calibration
    self.setCalibrationQNH(App.Properties.getValue("userCalibrationQNH"));
    // ... reference
    self.setReferenceElevation(App.Properties.getValue("userReferenceElevation"));
    self.setReferenceTemperatureISAOffset(App.Properties.getValue("userReferenceTemperatureISAOffset"));
    self.setReferenceTemperatureAuto(App.Properties.getValue("userReferenceTemperatureAuto"));
    // ... general
    self.setGeneralBackgroundColor(App.Properties.getValue("userGeneralBackgroundColor"));
    // ... units
    self.setUnitElevation(App.Properties.getValue("userUnitElevation"));
    self.setUnitPressure(App.Properties.getValue("userUnitPressure"));
    self.setUnitTemperature(App.Properties.getValue("userUnitTemperature"));
    self.setUnitTimeUTC(App.Properties.getValue("userUnitTimeUTC"));
    // ... correction
    self.setCorrectionAbsolute(App.Properties.getValue("userCorrectionAbsolute"));
    self.setCorrectionRelative(App.Properties.getValue("userCorrectionRelative"));
  }

  function setCalibrationQNH(_fCalibrationQNH) {  // [Pa]
    // REF: https://en.wikipedia.org/wiki/Atmospheric_pressure#Records
    if(_fCalibrationQNH == null) {
      _fCalibrationQNH = 101325.0f;
    }
    else if(_fCalibrationQNH > 110000.0f) {
      _fCalibrationQNH = 110000.0f;
    }
    else if(_fCalibrationQNH < 85000.0f) {
      _fCalibrationQNH = 85000.0f;
    }
    self.fCalibrationQNH = _fCalibrationQNH;
  }

  function setReferenceElevation(_fReferenceElevation) {  // [m]
    if(_fReferenceElevation == null) {
      _fReferenceElevation = 0.0f;
    }
    else if(_fReferenceElevation > 9999.0f) {
      _fReferenceElevation = 9999.0f;
    }
    else if(_fReferenceElevation < 0.0f) {
      _fReferenceElevation = 0.0f;
    }
    self.fReferenceElevation = _fReferenceElevation;
  }

  function setReferenceTemperatureISAOffset(_fReferenceTemperatureISAOffset) {  // [°K]
    if(_fReferenceTemperatureISAOffset == null) {
      _fReferenceTemperatureISAOffset = 0.0f;
    }
    else if(_fReferenceTemperatureISAOffset > 99.9f) {
      _fReferenceTemperatureISAOffset = 99.9f;
    }
    else if(_fReferenceTemperatureISAOffset < -99.9f) {
      _fReferenceTemperatureISAOffset = 99.9f;
    }
    self.fReferenceTemperatureISAOffset = _fReferenceTemperatureISAOffset;
  }

  function setReferenceTemperatureAuto(_bReferenceTemperatureAuto) {
    if(_bReferenceTemperatureAuto == null) {
      _bReferenceTemperatureAuto = false;
    }
    self.bReferenceTemperatureAuto = _bReferenceTemperatureAuto;
  }

  function setGeneralBackgroundColor(_iGeneralBackgroundColor) {
    if(_iGeneralBackgroundColor == null) {
      _iGeneralBackgroundColor = Gfx.COLOR_BLACK;
    }
    self.iGeneralBackgroundColor = _iGeneralBackgroundColor;
  }

  function setUnitElevation(_iUnitElevation) {
    if(_iUnitElevation == null or _iUnitElevation < 0 or _iUnitElevation > 1) {
      _iUnitElevation = -1;
    }
    self.iUnitElevation = _iUnitElevation;
    if(self.iUnitElevation < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
        _iUnitElevation = oDeviceSettings.elevationUnits;
      }
      else {
        _iUnitElevation = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitElevation == Sys.UNIT_STATUTE) {  // ... statute
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

  function setUnitPressure(_iUnitPressure) {
    if(_iUnitPressure == null or _iUnitPressure < 0 or _iUnitPressure > 1) {
      _iUnitPressure = -1;
    }
    self.iUnitPressure = _iUnitPressure;
    if(self.iUnitPressure < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred pressure units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnitPressure = oDeviceSettings.weightUnits;
      }
      else {
        _iUnitPressure = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitPressure == Sys.UNIT_STATUTE) {  // ... statute
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

  function setUnitTemperature(_iUnitTemperature) {
    if(_iUnitTemperature == null or _iUnitTemperature < 0 or _iUnitTemperature > 1) {
      _iUnitTemperature = -1;
    }
    self.iUnitTemperature = _iUnitTemperature;
    if(self.iUnitTemperature < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        _iUnitTemperature = oDeviceSettings.temperatureUnits;
      }
      else {
        _iUnitTemperature = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitTemperature == Sys.UNIT_STATUTE) {  // ... statute
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

  function setUnitTimeUTC(_bUnitTimeUTC) {
    if(_bUnitTimeUTC == null) {
      _bUnitTimeUTC = false;
    }
    if(_bUnitTimeUTC) {
      self.bUnitTimeUTC = true;
      self.sUnitTime = "Z";
    }
    else {
      self.bUnitTimeUTC = false;
      self.sUnitTime = "LT";
    }
  }

  function setCorrectionAbsolute(_fCorrectionAbsolute) {  // [Pa]
    if(_fCorrectionAbsolute == null) {
      _fCorrectionAbsolute = 0.0f;
    }
    else if(_fCorrectionAbsolute > 9999.0f) {
      _fCorrectionAbsolute = 9999.0f;
    }
    else if(_fCorrectionAbsolute < -9999.0f) {
      _fCorrectionAbsolute = -9999.0f;
    }
    self.fCorrectionAbsolute = _fCorrectionAbsolute;
  }

  function setCorrectionRelative(_fCorrectionRelative) {
    if(_fCorrectionRelative == null) {
      _fCorrectionRelative = 1.0f;
    }
    else if(_fCorrectionRelative > 1.9999f) {
      _fCorrectionRelative = 1.9999f;
    }
    else if(_fCorrectionRelative < 0.0001f) {
      _fCorrectionRelative = 0.0001f;
    }
    self.fCorrectionRelative = _fCorrectionRelative;
  }

}
