// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Generic ConnectIQ Helpers/Resources (CIQ Helpers)
// Copyright (C) 2017-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:glance)
module LangUtils {

  //
  // FUNCTIONS: data primitives
  //

  // NaN
  function isNaN(_nValue as Numeric?) as Boolean {
    return _nValue == null or _nValue != _nValue;
  }
  function notNaN(_nValue as Numeric?) as Boolean {
    return _nValue != null and _nValue == _nValue;
  }

  // Casting
  function asNumber(_oValue as Object or App.PropertyValueType, _nDefault as Number) as Number {
    if(_oValue != null && !(_oValue instanceof Lang.Number)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toNumber();
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue : _nDefault;
  }

  function asFloat(_oValue as Object or App.PropertyValueType, _fDefault as Float) as Float {
    if(_oValue != null && !(_oValue instanceof Lang.Float)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toFloat();
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue : _fDefault;
  }

  function asBoolean(_oValue as Object or App.PropertyValueType, _bDefault as Boolean) as Boolean {
    if(_oValue != null && !(_oValue instanceof Lang.Boolean)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toNumber() != 0;
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue : _bDefault;
  }

}
