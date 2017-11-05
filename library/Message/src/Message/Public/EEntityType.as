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



public class EEntityType
{
    public var __value : int;

    public static const _EEntityTypePlayer : int = 1;
    public static const _EEntityTypeBoss : int = 2;
    public static const _EEntityTypeDrop : int = 3;
    public static const _EEntityTypePet : int = 4;
    public static const _EEntityTypeGroup : int = 5;
    public static const _EEntityTypeEscort : int = 6;
    public static const _EEntityTypeGuild : int = 7;
    public static const _EEntityTypeVirBoss : int = 8;

    public static function convert( val : int ) : EEntityType
    {
        return new EEntityType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EEntityType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EEntityType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 9)
        {
            throw new MarshalException();
        }
        return EEntityType.convert(__v);
    }
}
}
