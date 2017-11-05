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


public class SCopyChannel
{
    public var channelId : int;

    public var copyCode : int;

    public var url : String;

    public var publicUrl : String;

    public var type : int;

    public function SCopyChannel()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(channelId);
        __os.writeInt(copyCode);
        __os.writeString(url);
        __os.writeString(publicUrl);
        __os.writeInt(type);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        channelId = __is.readInt();
        copyCode = __is.readInt();
        url = __is.readString();
        publicUrl = __is.readString();
        type = __is.readInt();
    }
}
}
