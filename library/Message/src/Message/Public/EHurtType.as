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



public class EHurtType
{
    public var __value : int;

    public static const _EHurtTypeNormal : int = 1;
    public static const _EHurtTypeCrush : int = 2;
    public static const _EHurtTypeCrit : int = 3;
    public static const _EHurtTypeJouk : int = 4;
    public static const _EHurtTypeBlock : int = 5;
    public static const _EHurtTypeSelfDestruction : int = 6;
    public static const _EHurtTypeCheatDeath : int = 7;
    public static const _EHurtTypeImmune : int = 8;

    public static function convert( val : int ) : EHurtType
    {
        return new EHurtType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EHurtType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EHurtType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 9)
        {
            throw new MarshalException();
        }
        return EHurtType.convert(__v);
    }
}
}
