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



public class EKickOutReason
{
    public var __value : int;

    public static const _EKickOutReasonBegin : int = 0;
    public static const _EKickOutReasonByCloseCell : int = 1;
    public static const _EKickOutReasonByCloseGateMgr : int = 2;
    public static const _EKickOutReasonByCloseGate : int = 3;
    public static const _EKickOutReasonByCloseCenter : int = 4;
    public static const _EKickOutReasonByCloseDbApp : int = 5;
    public static const _EKickOutReasonByElseLogin : int = 6;
    public static const _EKickOutReasonByIssmThreeHour : int = 7;
    public static const _EKickOutReasonByIssmOfflineTimeLessFiveHour : int = 8;
    public static const _EKickOutReasonByLockPlayer : int = 9;
    public static const _EKickOutReasonByGMOperation : int = 10;
    public static const _EKickOutReasonByDbUpdateFail : int = 11;
    public static const _EKickOutReasonByErrorVersion : int = 12;
    public static const _EKickOutReasonByDataError : int = 13;
    public static const _EKickOutReasonEnd : int = 14;

    public static function convert( val : int ) : EKickOutReason
    {
        return new EKickOutReason( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EKickOutReason( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EKickOutReason
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 15)
        {
            throw new MarshalException();
        }
        return EKickOutReason.convert(__v);
    }
}
}
