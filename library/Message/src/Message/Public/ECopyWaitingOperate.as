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



public class ECopyWaitingOperate
{
    public var __value : int;

    public static const _ECopyWaitingQuit : int = 0;
    public static const _ECopyWaitingEnter : int = 1;
    public static const _ECopyWaitingSignUp : int = 2;
    public static const _ECopyWaitingUnSign : int = 3;
    public static const _ECopyWaitingInvite : int = 4;
    public static const _ECopyWaitingGather : int = 5;
    public static const _ECopyWaitingRefuseGather : int = 6;
    public static const _ECopyWaitingQuickGroup : int = 7;

    public static function convert( val : int ) : ECopyWaitingOperate
    {
        return new ECopyWaitingOperate( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECopyWaitingOperate( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ECopyWaitingOperate
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 8)
        {
            throw new MarshalException();
        }
        return ECopyWaitingOperate.convert(__v);
    }
}
}
