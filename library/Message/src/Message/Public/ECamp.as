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



public class ECamp
{
    public var __value : int;

    public static const _ECampNo : int = 0;
    public static const _ECampA : int = 1;
    public static const _ECampB : int = 2;
    public static const _ECampC : int = 3;

    public static function convert( val : int ) : ECamp
    {
        return new ECamp( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECamp( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ECamp
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 4)
        {
            throw new MarshalException();
        }
        return ECamp.convert(__v);
    }
}
}
