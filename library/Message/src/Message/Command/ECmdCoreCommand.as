// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Command{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class ECmdCoreCommand
{
    public var __value : int;

    public static const _ECmdCoreChannelUpdate : int = 5000;
    public static const _ECmdCoreCellUpdate : int = 5001;
    public static const _ECmdCoreKillUser : int = 5002;
    public static const _ECmdCoreStopServer : int = 5003;
    public static const _ECmdCoreStartServer : int = 5004;

    public static function convert( val : int ) : ECmdCoreCommand
    {
        return new ECmdCoreCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECmdCoreCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : ECmdCoreCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 5005)
        {
            throw new MarshalException();
        }
        return ECmdCoreCommand.convert(__v);
    }
}
}
