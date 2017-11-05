// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class EQuality
{
    public var __value : int;

    public static const _EQuality0 : int = 0;
    public static const _EQuality1 : int = 1;
    public static const _EQuality2 : int = 2;
    public static const _EQuality3 : int = 3;
    public static const _EQuality4 : int = 4;
    public static const _EQuality5 : int = 5;
    public static const _EQuality6 : int = 6;
    public static const _EQuality7 : int = 7;
    public static const _EQuality8 : int = 8;
    public static const _EQuality9 : int = 9;

    public static function convert( val : int ) : EQuality
    {
        return new EQuality( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EQuality( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EQuality
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 10)
        {
            throw new MarshalException();
        }
        return EQuality.convert(__v);
    }
}
}
