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



public interface IMarketPrx 
{
    function search_async( __cb : AMI_IMarket_search, recordType : int , marketId : int , codes : Array , targetPage : int , levelLower : int , levelUpper : int , color : int , career : int , order : int , playerName : String ) : void ;

    function getMyRecords_async( __cb : AMI_IMarket_getMyRecords, recordType : int ) : void ;

    function buyMarketItem_async( __cb : AMI_IMarket_buyMarketItem, recordId : Number ) : void ;

    function sellItem_async( __cb : AMI_IMarket_sellItem, code : int , itemUid : String , amount : int , price : int , unit : int , time : int , broadcast : Boolean ) : void ;

    function cancelSell_async( __cb : AMI_IMarket_cancelSell, recordId : Number ) : void ;

    function sellItem2SeekBuy_async( __cb : AMI_IMarket_sellItem2SeekBuy, recordId : Number , uid : String , amount : int ) : void ;

    function seekBuy_async( __cb : AMI_IMarket_seekBuy, code : int , amount : int , price : int , unit : int , time : int , broadcast : Boolean ) : void ;

    function cancelSeekBuy_async( __cb : AMI_IMarket_cancelSeekBuy, recordId : Number ) : void ;

    function broadcastMarketRecord_async( __cb : AMI_IMarket_broadcastMarketRecord, recordId : Number ) : void ;

    function getMarketRecordById_async( __cb : AMI_IMarket_getMarketRecordById, recordId : Number ) : void ;
}
}
