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


public class SMapDeathEvent
{
    public var type : int;

    public var event : int;

    public var lower : int;

    public var upper : int;

    public var value : int;

    public function SMapDeathEvent()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        __os.writeInt(event);
        __os.writeInt(lower);
        __os.writeInt(upper);
        __os.writeInt(value);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        event = __is.readInt();
        lower = __is.readInt();
        upper = __is.readInt();
        value = __is.readInt();
    }
}
}
