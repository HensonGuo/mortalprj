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



public class IMarketPrxHelper extends RMIProxyObject implements IMarketPrx
{
    
    public static const NAME:String = "Message.Game.IMarket";

    
    public function IMarketPrxHelper()
    {
        name = "IMarket";
    }

    public function broadcastMarketRecord_async( __cb : AMI_IMarket_broadcastMarketRecord, recordId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "broadcastMarketRecord" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function buyMarketItem_async( __cb : AMI_IMarket_buyMarketItem, recordId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "buyMarketItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function cancelSeekBuy_async( __cb : AMI_IMarket_cancelSeekBuy, recordId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "cancelSeekBuy" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function cancelSell_async( __cb : AMI_IMarket_cancelSell, recordId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "cancelSell" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getMarketRecordById_async( __cb : AMI_IMarket_getMarketRecordById, recordId : Number ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getMarketRecordById" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getMyRecords_async( __cb : AMI_IMarket_getMyRecords, recordType : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getMyRecords" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(recordType);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function search_async( __cb : AMI_IMarket_search, recordType : int , marketId : int , codes : Array , targetPage : int , levelLower : int , levelUpper : int , color : int , career : int , order : int , playerName : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "search" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(recordType);
        __os.writeInt(marketId);
        SeqIntHelper.write(__os, codes);
        __os.writeInt(targetPage);
        __os.writeInt(levelLower);
        __os.writeInt(levelUpper);
        __os.writeInt(color);
        __os.writeInt(career);
        __os.writeInt(order);
        __os.writeString(playerName);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function seekBuy_async( __cb : AMI_IMarket_seekBuy, code : int , amount : int , price : int , unit : int , time : int , broadcast : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "seekBuy" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(code);
        __os.writeInt(amount);
        __os.writeInt(price);
        __os.writeInt(unit);
        __os.writeInt(time);
        __os.writeBool(broadcast);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sellItem_async( __cb : AMI_IMarket_sellItem, code : int , itemUid : String , amount : int , price : int , unit : int , time : int , broadcast : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sellItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(code);
        __os.writeString(itemUid);
        __os.writeInt(amount);
        __os.writeInt(price);
        __os.writeInt(unit);
        __os.writeInt(time);
        __os.writeBool(broadcast);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sellItem2SeekBuy_async( __cb : AMI_IMarket_sellItem2SeekBuy, recordId : Number , uid : String , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sellItem2SeekBuy" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeLong(recordId);
        __os.writeString(uid);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

