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


public class SSessionKey
{
    public var id : Number;

    public var key : String;

    public function SSessionKey()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeLong(id);
        __os.writeString(key);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        id = __is.readLong();
        key = __is.readString();
    }
}
}
