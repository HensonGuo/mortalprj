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



public class IPanicBuyPrxHelper extends RMIProxyObject implements IPanicBuyPrx
{
    
    public static const NAME:String = "Message.Game.IPanicBuy";

    
    public function IPanicBuyPrxHelper()
    {
        name = "IPanicBuy";
    }

    public function buyItem_async( __cb : AMI_IPanicBuy_buyItem, itemCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "buyItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(itemCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function closePanicBuyPanel_async( __cb : AMI_IPanicBuy_closePanicBuyPanel) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "closePanicBuyPanel" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getPanicBuyConfig_async( __cb : AMI_IPanicBuy_getPanicBuyConfig) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getPanicBuyConfig" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
