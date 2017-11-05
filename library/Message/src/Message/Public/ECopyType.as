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



public class ECopyType
{
    public var __value : int;

    public static const _ECopyTypeNormal : int = 0;
    public static const _ECopyTypeTower : int = 1;
    public static const _ECopyTypeDefense : int = 2;
    public static const _ECopyTypeDrama : int = 3;
    public static const _ECopyTypeCoin : int = 4;
    public static const _ECopyTypePush : int = 5;
    public static const _ECopyTypeBattlefield : int = 6;
    public static const _ECopyTypeArena : int = 7;
    public static const _ECopyTypeVip : int = 8;
    public static const _ECopyTypeWedding : int = 9;

    public static function convert( val : int ) : ECopyType
    {
        return new ECopyType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECopyType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ECopyType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 10)
        {
            throw new MarshalException();
        }
        return ECopyType.convert(__v);
    }
}
}
