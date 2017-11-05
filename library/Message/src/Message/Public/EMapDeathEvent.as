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



public class EMapDeathEvent
{
    public var __value : int;

    public static const _EMapDeathEventPass : int = 1;
    public static const _EMapDeathEventHonour : int = 2;
    public static const _EMapDeathEventExp : int = 3;
    public static const _EMapDeathEventContri : int = 4;
    public static const _EMapDeathEventPrestige : int = 5;
    public static const _EMapDeathEventItem : int = 6;
    public static const _EMapDeathEventBuff : int = 7;

    public static function convert( val : int ) : EMapDeathEvent
    {
        return new EMapDeathEvent( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMapDeathEvent( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EMapDeathEvent
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 8)
        {
            throw new MarshalException();
        }
        return EMapDeathEvent.convert(__v);
    }
}
}
