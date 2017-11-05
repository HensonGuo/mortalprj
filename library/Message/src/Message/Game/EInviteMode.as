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



public class EInviteMode
{
    public var __value : int;

    public static const _EInviteForCreateGuild : int = 0;
    public static const _EInviteForJoinGuild : int = 1;

    public static function convert( val : int ) : EInviteMode
    {
        return new EInviteMode( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EInviteMode( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EInviteMode
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 2)
        {
            throw new MarshalException();
        }
        return EInviteMode.convert(__v);
    }
}
}
