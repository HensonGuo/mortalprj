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



public class IShopPrxHelper extends RMIProxyObject implements IShopPrx
{
    
    public static const NAME:String = "Message.Game.IShop";

    
    public function IShopPrxHelper()
    {
        name = "IShop";
    }

    public function buy_async( __cb : AMI_IShop_buy, npcId : int , shopCode : int , itemCode : int , amount : int , priorityFlag : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "buy" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(npcId);
        __os.writeInt(shopCode);
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        __os.writeInt(priorityFlag);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function buyAndUse_async( __cb : AMI_IShop_buyAndUse, npcId : int , shopCode : int , itemCode : int , amount : int , useAmount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "buyAndUse" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(npcId);
        __os.writeInt(shopCode);
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        __os.writeInt(useAmount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function buyBack_async( __cb : AMI_IShop_buyBack, uids : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "buyBack" );
        var __os : SerializeStream = new SerializeStream();
        SeqStringHelper.write(__os, uids);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getSellList_async( __cb : AMI_IShop_getSellList) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getSellList" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

