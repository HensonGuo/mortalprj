// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Engine.RMI{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;


//[Bindable]
public class SRMIReturn
{
    public var messageId : int;

    public var dispatchStatus : ERMIDispatchStatus;

    public var userKey : int;

    [ArrayElementType("int")]
    public var routerMap : Array;

    public function SRMIReturn()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(messageId);
        dispatchStatus.__write(__os);
        __os.writeInt(userKey);
        SeqRouterMapHelper.write(__os, routerMap);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        messageId = __is.readInt();
        dispatchStatus = ERMIDispatchStatus.__read(__is);
        userKey = __is.readInt();
        routerMap = SeqRouterMapHelper.read(__is);
    }
}
}
