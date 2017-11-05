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


public class STaskEffect
{
    public var effect : int;

    public var effect1 : int;

    public var effect2 : int;

    public var effectStr : String;

    public function STaskEffect()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(effect);
        __os.writeInt(effect1);
        __os.writeInt(effect2);
        __os.writeString(effectStr);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        effect = __is.readInt();
        effect1 = __is.readInt();
        effect2 = __is.readInt();
        effectStr = __is.readString();
    }
}
}
