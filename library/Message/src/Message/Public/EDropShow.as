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



public class EDropShow
{
    public var __value : int;

    public static const _EDropShowSelf : int = 0;
    public static const _EDropShowAll : int = 1;

    public static function convert( val : int ) : EDropShow
    {
        return new EDropShow( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EDropShow( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EDropShow
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 2)
        {
            throw new MarshalException();
        }
        return EDropShow.convert(__v);
    }
}
}
