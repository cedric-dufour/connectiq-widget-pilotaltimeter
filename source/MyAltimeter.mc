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
using Toybox.Math;
using Toybox.System as Sys;

// REFERENCES:
//   https://store.icao.int/manual-on-automatic-meteorological-observing-systems-at-aerodromes-2011-doc-9837-english-printed.html ($$$)
//   https://www.wmo.int/pages/prog/www/IMOP/meetings/SI/ET-Stand-1/Doc-10_Pressure-red.pdf
//   https://en.wikipedia.org/wiki/Density_altitude#Calculation

//
// CLASS
//

(:glance)
class MyAltimeter {

  //
  // CONSTANTS
  //

  // International Standard Atmosphere (ISA)
  public const ISA_PRESSURE_MSL = 101325.0f;  // [Pa] aka. QNE
  public const ISA_TEMPERATURE_MSL = 288.15f;  // [°K]
  public const ISA_TEMPERATURE_LRATE = -0.0065f;  // [°K/m]

  // International Civil Aviation Organization (OACI)
  public const ICAO_ALTITUDE_K1 = 44330.77f;
  public const ICAO_ALTITUDE_K2 = -11880.32f;
  public const ICAO_ALTITUDE_EXP = 0.190263f;
  public const ICAO_PRESSURE_EXP = 5.25588f;

  // Density Altitude
  public const DA_EXP = 0.234978f;


  //
  // VARIABLES
  //

  // Pressure
  public var fQNH as Float = 101325.0f;  // [Pa]
  public var fQFE_raw as Float = NaN;  // [Pa]
  public var fQFE as Float = NaN;  // [Pa]

  // Altitude
  public var fAltitudeISA as Float = NaN;  // [m]
  public var fAltitudeActual as Float = NaN;  // [m]
  public var fAltitudeDensity as Float = NaN;  // [m]

  // Temperature
  public var fTemperatureISA as Float = NaN;  // [°K]
  public var fTemperatureActual as Float = NaN;  // [°K]
  private var bTemperatureActualSet as Boolean = false;


  //
  // FUNCTIONS: self
  //

  function reset() as Void {
    // Pressure
    self.fQFE_raw = NaN;
    self.fQFE = NaN;

    // Altitude
    self.fAltitudeISA = NaN;
    self.fAltitudeActual = NaN;
    self.fAltitudeDensity = NaN;

    // Temperature
    self.fTemperatureISA = NaN;
    self.fTemperatureActual = NaN;
    self.bTemperatureActualSet = false;
  }

  function importSettings() as Void {
    // QNH
    self.fQNH = $.oMySettings.fCalibrationQNH;
  }

  function setQFE(_fQFE as Float) as Void {  // [Pa]
    // Raw sensor value
    self.fQFE_raw = _fQFE;
    //Sys.println(format("DEBUG: QFE (raw) = $1$", [self.fQFE_raw]));

    // Calibrated value
    self.fQFE = self.fQFE_raw * $.oMySettings.fCorrectionRelative + $.oMySettings.fCorrectionAbsolute;
    //Sys.println(format("DEBUG: QFE (calibrated) = $1$", [self.fQFE]));

    // Derive altitudes (ICAO formula)
    // ... ISA (QNH=QNE)
    self.fAltitudeISA = self.ICAO_ALTITUDE_K1 + self.ICAO_ALTITUDE_K2 * Math.pow(self.fQFE/100.0f, self.ICAO_ALTITUDE_EXP).toFloat();
    //Sys.println(format("DEBUG: Altitude (ISA) = $1$", [self.fAltitudeISA]));
    // ... actual
    self.fAltitudeActual = self.fAltitudeISA - (Math.pow(self.fQNH/self.ISA_PRESSURE_MSL, self.ICAO_ALTITUDE_EXP).toFloat() - 1.0f)*self.ISA_TEMPERATURE_MSL/self.ISA_TEMPERATURE_LRATE;
    //Sys.println(format("DEBUG: Altitude (actual) = $1$", [self.fAltitudeActual]));

    // Post-process
    self.postProcess();
  }

  function setQNH(_fQNH as Float) as Void {  // [Pa]
    // QNH
    self.fQNH = _fQNH;

    // ISA altitude (<-> QFE) available ?
    if(LangUtils.notNaN(self.fAltitudeISA)) {
      // Derive altitude (ICAO formula)
      // ... actual
      self.fAltitudeActual = self.fAltitudeISA - (Math.pow(self.fQNH/self.ISA_PRESSURE_MSL, self.ICAO_ALTITUDE_EXP).toFloat() - 1.0f)*self.ISA_TEMPERATURE_MSL/self.ISA_TEMPERATURE_LRATE;
      //Sys.println(format("DEBUG: Altitude (actual) = $1$", [self.fAltitudeActual]));

      // Post-process
      self.postProcess();
    }
  }

  function setAltitudeActual(_fAltitudeActual as Float) as Void {  // [m]
    // ISA altitude (<-> QFE) available ?
    if(LangUtils.notNaN(self.fAltitudeISA)) {
      // Derive QNH (ICAO formula)
      self.fQNH = self.ISA_PRESSURE_MSL * Math.pow(1.0f + self.ISA_TEMPERATURE_LRATE*(self.fAltitudeISA-_fAltitudeActual)/self.ISA_TEMPERATURE_MSL, self.ICAO_PRESSURE_EXP).toFloat();
      //Sys.println(format("DEBUG: QNH = $1$", [self.fQNH]));

      // Save altitude
      // ... actual
      self.fAltitudeActual = _fAltitudeActual;

      // Post-process
      self.postProcess();
    }
  }

  function setTemperatureActual(_fTemperatureActual as Float?) as Void {  // [°K]
    // Save temperature
    // ... actual
    if(_fTemperatureActual != null and LangUtils.notNaN(_fTemperatureActual)) {
      self.fTemperatureActual = _fTemperatureActual;
      self.bTemperatureActualSet = true;
      //Sys.println(format("DEBUG: Temperature (actual) (set) = $1$", [self.fTemperatureActual]));
    }
    else {
      self.bTemperatureActualSet = false;
    }

    // Post-process
    // NO! This only affects Density Altitude, which will be updated on setQFE()
  }

  function postProcess() as Void {
    // Derive temperature
    // ... ISA
    self.fTemperatureISA = self.ISA_TEMPERATURE_MSL + self.ISA_TEMPERATURE_LRATE * self.fAltitudeActual;
    //Sys.println(format("DEBUG: Temperature (ISA) = $1$", [self.fTemperatureISA]));
    // ... actual
    if(!self.bTemperatureActualSet or LangUtils.isNaN(self.fTemperatureActual)) {
      self.fTemperatureActual = self.fTemperatureISA + $.oMySettings.fReferenceTemperatureISAOffset;
    }
    //Sys.println(format("DEBUG: Temperature (actual, calculated) = $1$", [self.fTemperatureActual]));

    // Derive altitude
    // ... density
    self.fAltitudeDensity = self.ISA_TEMPERATURE_MSL/self.ISA_TEMPERATURE_LRATE * (Math.pow(self.fQFE*self.ISA_TEMPERATURE_MSL/self.ISA_PRESSURE_MSL/self.fTemperatureActual, self.DA_EXP).toFloat() - 1.0f);
    //Sys.println(format("DEBUG: Altitude (density) = $1$", [self.fAltitudeDensity]));
  }

}
