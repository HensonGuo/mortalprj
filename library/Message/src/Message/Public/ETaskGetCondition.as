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



public class ETaskGetCondition
{
    public var __value : int;

    public static const _ETaskGetConditionLevel : int = 1;
    public static const _ETaskGetConditionTask : int = 2;
    public static const _ETaskGetConditionCareer : int = 3;
    public static const _ETaskGetConditionCamp : int = 4;
    public static const _ETaskGetConditionForce : int = 5;
    public static const _ETaskGetConditionServer : int = 6;
    public static const _ETaskGetConditionVip : int = 7;
    public static const _ETaskGetConditionMarriage : int = 8;
    public static const _ETaskGetConditionServerOpenTime : int = 9;
    public static const _ETaskGetConditionOnlineTime : int = 10;

    public static function convert( val : int ) : ETaskGetCondition
    {
        return new ETaskGetCondition( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ETaskGetCondition( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ETaskGetCondition
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 11)
        {
            throw new MarshalException();
        }
        return ETaskGetCondition.convert(__v);
    }
}
}
