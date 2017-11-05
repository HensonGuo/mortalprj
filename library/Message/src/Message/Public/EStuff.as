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



public class EStuff
{
    public var __value : int;

    public static const _EStuffJewel : int = 40;
    public static const _EStuffAdvance : int = 41;
    public static const _EStuffAtlas : int = 42;
    public static const _EStuffLife : int = 43;

    public static function convert( val : int ) : EStuff
    {
        return new EStuff( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EStuff( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EStuff
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 44)
        {
            throw new MarshalException();
        }
        return EStuff.convert(__v);
    }
}
}
