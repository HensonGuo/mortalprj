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


public class SCellInfo
{
    public var cellId : int;

    public var channelId : int;

    public var url : String;

    public var spaceId : int;

    public var rect : SRect;

    public function SCellInfo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(cellId);
        __os.writeInt(channelId);
        __os.writeString(url);
        __os.writeInt(spaceId);
        rect.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        cellId = __is.readInt();
        channelId = __is.readInt();
        url = __is.readString();
        spaceId = __is.readInt();
        rect = new SRect();
        rect.__read(__is);
    }
}
}
