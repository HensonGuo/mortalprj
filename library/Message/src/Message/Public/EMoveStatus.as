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



public class EMoveStatus
{
    public var __value : int;

    public static const _EMoveStatusNormal : int = 0;
    public static const _EMoveStatusJump : int = 1;
    public static const _EMoveStatusSomersault : int = 2;
    public static const _EMoveStatusJumpPoint : int = 3;
    public static const _EMoveStatusCollect : int = 4;

    public static function convert( val : int ) : EMoveStatus
    {
        return new EMoveStatus( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMoveStatus( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EMoveStatus
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 5)
        {
            throw new MarshalException();
        }
        return EMoveStatus.convert(__v);
    }
}
}
