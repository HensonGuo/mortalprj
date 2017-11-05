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



public class EFriendFlag
{
    public var __value : int;

    public static const _EFriendFlagDelete : int = 0;
    public static const _EFriendFlagFriend : int = 1;
    public static const _EFriendFlagBlackList : int = 2;
    public static const _EFriendFlagEnemy : int = 4;
    public static const _EFriendFlagVictim : int = 8;

    public static function convert( val : int ) : EFriendFlag
    {
        return new EFriendFlag( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EFriendFlag( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EFriendFlag
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 9)
        {
            throw new MarshalException();
        }
        return EFriendFlag.convert(__v);
    }
}
}
