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


public class SPassTo
{
    public var passToId : int;

    public var name : String;

    public var mapId : int;

    public var toPoint : SPoint;

    public function SPassTo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(passToId);
        __os.writeString(name);
        __os.writeInt(mapId);
        toPoint.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        passToId = __is.readInt();
        name = __is.readString();
        mapId = __is.readInt();
        toPoint = new SPoint();
        toPoint.__read(__is);
    }
}
}
