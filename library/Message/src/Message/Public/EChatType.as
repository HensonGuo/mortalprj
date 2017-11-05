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



public class EChatType
{
    public var __value : int;

    public static const _EChatTypeWorld : int = 1;
    public static const _EChatTypeCamp : int = 2;
    public static const _EChatTypeGuild : int = 3;
    public static const _EChatTypeTeam : int = 4;
    public static const _EChatTypeForce : int = 5;
    public static const _EChatTypeSpace : int = 6;
    public static const _EChatTypeCross : int = 7;
    public static const _EChatTypePrivate : int = 8;
    public static const _EChatTypeTrumpet : int = 9;
    public static const _EChatTypeSystem : int = 10;
    public static const _EChatTypeGuildRoll : int = 11;
    public static const _EChatTypeCopy : int = 12;
    public static const _EChatTypeMarket : int = 13;
    public static const _EChatTypeRumor : int = 14;

    public static function convert( val : int ) : EChatType
    {
        return new EChatType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EChatType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EChatType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 15)
        {
            throw new MarshalException();
        }
        return EChatType.convert(__v);
    }
}
}
