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



public class EJewelQuality
{
    public var __value : int;

    public static const _EJewelQuality1 : int = 2;
    public static const _EJewelQuality2 : int = 3;
    public static const _EJewelQuality3 : int = 4;
    public static const _EJewelQuality4 : int = 5;

    public static function convert( val : int ) : EJewelQuality
    {
        return new EJewelQuality( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EJewelQuality( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EJewelQuality
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 6)
        {
            throw new MarshalException();
        }
        return EJewelQuality.convert(__v);
    }
}
}
