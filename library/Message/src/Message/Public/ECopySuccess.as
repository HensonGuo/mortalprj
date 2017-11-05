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



public class ECopySuccess
{
    public var __value : int;

    public static const _ECopySuccessNone : int = 0;
    public static const _ECopySuccessKill : int = 1;
    public static const _ECopySuccessTrigger : int = 2;

    public static function convert( val : int ) : ECopySuccess
    {
        return new ECopySuccess( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECopySuccess( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ECopySuccess
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 3)
        {
            throw new MarshalException();
        }
        return ECopySuccess.convert(__v);
    }
}
}
