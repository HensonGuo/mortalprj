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
public class SRMICall
{
    public var messageId : int;

    public var callSynchType : ERMICallModel;

    public var identity : SIdentity;

    public var operation : String;

    public var userKey : int;

    [ArrayElementType("int")]
    public var routerMap : Array;

    public function SRMICall()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(messageId);
        callSynchType.__write(__os);
        identity.__write(__os);
        __os.writeString(operation);
        __os.writeInt(userKey);
        SeqRouterMapHelper.write(__os, routerMap);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        messageId = __is.readInt();
        callSynchType = ERMICallModel.__read(__is);
        identity = new SIdentity();
        identity.__read(__is);
        operation = __is.readString();
        userKey = __is.readInt();
        routerMap = SeqRouterMapHelper.read(__is);
    }
}
}
