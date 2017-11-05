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
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;



public class IKeepActivePrxHelper extends RMIProxyObject implements IKeepActivePrx
{
    
    public static const NAME:String = "Engine.RMI.IKeepActive";

    
    public function IKeepActivePrxHelper()
    {
        name = "IKeepActive";
    }

    public function keepActive_async( __cb : AMI_IKeepActive_keepActive) : void 
    {
        var __context : Context = new Context;
        __context._session = session;
        __context._connection = session.connection;
        __context._timeOut = this.timeOut;
        var __call : SRMICall = new SRMICall;
        __call.identity = identity;
        __call.operation = "keepActive";
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
