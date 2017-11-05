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



public class EBuffEffect
{
    public var __value : int;

    public static const _EBuffEffectLastDamage : int = 1;
    public static const _EBuffEffectConfusion : int = 2;
    public static const _EBuffEffectSleep : int = 4;
    public static const _EBuffEffectDizzy : int = 8;
    public static const _EBuffEffectSilence : int = 16;
    public static const _EBuffEffectMock : int = 32;
    public static const _EBuffEffectHoldStill : int = 64;
    public static const _EBuffEffectDesSpeed : int = 128;

    public static function convert( val : int ) : EBuffEffect
    {
        return new EBuffEffect( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EBuffEffect( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EBuffEffect
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 129)
        {
            throw new MarshalException();
        }
        return EBuffEffect.convert(__v);
    }
}
}
