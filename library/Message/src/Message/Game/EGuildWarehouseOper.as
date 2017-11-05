// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class EGuildWarehouseOper
{
    public var __value : int;

    public static const _EGuildWarehouseIn : int = 0;
    public static const _EGuildWarehouseOut : int = 1;
    public static const _EGuildWarehouseSellIn : int = 2;
    public static const _EGuildWarehouseSellOut : int = 3;
    public static const _EGuildWarehouseMove : int = 4;

    public static function convert( val : int ) : EGuildWarehouseOper
    {
        return new EGuildWarehouseOper( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EGuildWarehouseOper( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EGuildWarehouseOper
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 5)
        {
            throw new MarshalException();
        }
        return EGuildWarehouseOper.convert(__v);
    }
}
}
