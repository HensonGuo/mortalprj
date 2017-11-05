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



public class ETestAppCommand
{
    public var __value : int;

    public static const _ECmdTestAppLogin : int = 2000;
    public static const _ECmdTestAppLoginGame : int = 2001;
    public static const _ECmdTestAppCreateRole : int = 2002;

    public static function convert( val : int ) : ETestAppCommand
    {
        return new ETestAppCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ETestAppCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : ETestAppCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 2003)
        {
            throw new MarshalException();
        }
        return ETestAppCommand.convert(__v);
    }
}
}
