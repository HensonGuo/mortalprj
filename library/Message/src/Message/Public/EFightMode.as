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



public class EFightMode
{
    public var __value : int;

    public static const _EFightModeFree : int = 1;
    public static const _EFightModeTeam : int = 2;
    public static const _EFightModeGuild : int = 4;
    public static const _EFightModeCamp : int = 8;
    public static const _EFightModeUnion : int = 16;
    public static const _EFightModeServer : int = 32;
    public static const _EFightModeForce : int = 64;
    public static const _EFightModePeace : int = 128;

    public static function convert( val : int ) : EFightMode
    {
        return new EFightMode( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EFightMode( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EFightMode
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 129)
        {
            throw new MarshalException();
        }
        return EFightMode.convert(__v);
    }
}
}
