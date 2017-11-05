// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Framework.MQ{

import Framework.MQ.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;


//[Bindable]
public class MessageHead
{
    public var command : int;

    public var channelId : int;

    [ArrayElementType("HandlerId")]
    public var fromIds : Array;

    [ArrayElementType("HandlerId")]
    public var toIds : Array;

    public function MessageHead()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeSize(command);
        //__os.writeInt(channelId);
        SeqHandlerIdHelper.write(__os, fromIds);
        SeqHandlerIdHelper.write(__os, toIds);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        command = __is.readSize();
        //channelId = __is.readInt();
        fromIds = SeqHandlerIdHelper.read(__is);
        toIds = SeqHandlerIdHelper.read(__is);
    }
}
}

