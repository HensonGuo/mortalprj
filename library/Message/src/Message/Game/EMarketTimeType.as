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



public class EMarketTimeType
{
    public var __value : int;

    public static const _EMarketTimeTypeEight : int = 8;
    public static const _EMarketTimeTypeTwentyFour : int = 24;
    public static const _EMarketTimeTypeFortyEight : int = 48;

    public static function convert( val : int ) : EMarketTimeType
    {
        return new EMarketTimeType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMarketTimeType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EMarketTimeType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 49)
        {
            throw new MarshalException();
        }
        return EMarketTimeType.convert(__v);
    }
}
}
