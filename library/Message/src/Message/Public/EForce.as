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



public class EForce
{
    public var __value : int;

    public static const _EForceNormal : int = 0;
    public static const _EForceA : int = 1;
    public static const _EForceB : int = 2;
    public static const _EForceC : int = 3;
    public static const _EForceServer : int = 4;
    public static const _EForceNeutral : int = 5;
    public static const _EForceDecorate : int = 6;
    public static const _EForceGuild : int = 7;
    public static const _EForceForce1 : int = 8;
    public static const _EForceForce2 : int = 9;
    public static const _EForceForce3 : int = 10;
    public static const _EForceForce4 : int = 11;

    public static function convert( val : int ) : EForce
    {
        return new EForce( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EForce( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EForce
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 12)
        {
            throw new MarshalException();
        }
        return EForce.convert(__v);
    }
}
}
