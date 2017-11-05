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



public class IInterPrxHelper extends RMIProxyObject implements IInterPrx
{
    
    public static const NAME:String = "Message.Game.IInter";

    
    public function IInterPrxHelper()
    {
        name = "IInter";
    }

    public function chat_async( __cb : AMI_IInter_chat, chatMsg : SChatMsg ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "chat" );
        var __os : SerializeStream = new SerializeStream();
        chatMsg.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
