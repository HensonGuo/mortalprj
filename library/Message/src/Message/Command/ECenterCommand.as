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



public class ECenterCommand
{
    public var __value : int;

    public static const _ECmdCenterToGateTest : int = 40001;
    public static const _ECmdCenterToGateBroadCastTest : int = 40002;
    public static const _ECmdCenterInterfaceList : int = 40003;

    public static function convert( val : int ) : ECenterCommand
    {
        return new ECenterCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECenterCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt( __value );
    }

    public static function __read( __is : SerializeStream ) : ECenterCommand
    {
        var __v : int = __is.readInt();
        if(__v < 0 || __v >= 40004)
        {
            throw new MarshalException();
        }
        return ECenterCommand.convert(__v);
    }
}
}
