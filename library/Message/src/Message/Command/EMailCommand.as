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



public class EMailCommand
{
    public var __value : int;

    public static const _ECmdMailLoadSysMailSuccess : int = 3000;

    public static function convert( val : int ) : EMailCommand
    {
        return new EMailCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMailCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EMailCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 3001)
        {
            throw new MarshalException();
        }
        return EMailCommand.convert(__v);
    }
}
}
