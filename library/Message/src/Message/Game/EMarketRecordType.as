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



public class EMarketRecordType
{
    public var __value : int;

    public static const _EMarketRecordSell : int = 0;
    public static const _EMarketRecordSeekBuy : int = 1;

    public static function convert( val : int ) : EMarketRecordType
    {
        return new EMarketRecordType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMarketRecordType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EMarketRecordType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 2)
        {
            throw new MarshalException();
        }
        return EMarketRecordType.convert(__v);
    }
}
}
