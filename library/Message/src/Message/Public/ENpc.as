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



public class ENpc
{
    public var __value : int;

    public static const _ENpcShop : int = 10000;

    public static function convert( val : int ) : ENpc
    {
        return new ENpc( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ENpc( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : ENpc
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 10001)
        {
            throw new MarshalException();
        }
        return ENpc.convert(__v);
    }
}
}
