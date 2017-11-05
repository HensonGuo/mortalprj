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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class IBusinessPrxHelper extends RMIProxyObject implements IBusinessPrx
{
    
    public static const NAME:String = "Message.Game.IBusiness";

    
    public function IBusinessPrxHelper()
    {
        name = "IBusiness";
    }

    public function doApply_async( __cb : AMI_IBusiness_doApply, entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "doApply" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function doOperation_async( __cb : AMI_IBusiness_doOperation, oper : EBusinessOperation , businessId : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "doOperation" );
        var __os : SerializeStream = new SerializeStream();
        oper.__write(__os);
        __os.writeString(businessId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateItem_async( __cb : AMI_IBusiness_updateItem, businessId : String , itemId : String , count : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(businessId);
        __os.writeString(itemId);
        __os.writeInt(count);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateMoney_async( __cb : AMI_IBusiness_updateMoney, businessId : String , unit : EPrictUnit , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateMoney" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(businessId);
        unit.__write(__os);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

