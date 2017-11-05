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



public class EDBCommand
{
    public var __value : int;

    public static const _ECmdDBCachePlayerDataSuccess : int = 4000;
    public static const _ECmdDBCachePlayerDataFail : int = 4001;
    public static const _ECmdDBUnCachePlayerData : int = 4002;
    public static const _ECmdDBCachePublicNotice : int = 4003;
    public static const _ECmdDBReloadLockIp : int = 4004;
    public static const _ECmdDBReloadPublicNotice : int = 4005;
    public static const _ECmdDBCacheOperationOnline : int = 4006;
    public static const _ECmdDBLoadSysMailSuccess : int = 4007;

    public static function convert( val : int ) : EDBCommand
    {
        return new EDBCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EDBCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EDBCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 4008)
        {
            throw new MarshalException();
        }
        return EDBCommand.convert(__v);
    }
}
}
