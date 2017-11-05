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



public interface IShopPrx 
{
    function buy_async( __cb : AMI_IShop_buy, npcId : int , shopCode : int , itemCode : int , amount : int , priorityFlag : int ) : void ;

    function buyAndUse_async( __cb : AMI_IShop_buyAndUse, npcId : int , shopCode : int , itemCode : int , amount : int , useAmount : int ) : void ;

    function buyBack_async( __cb : AMI_IShop_buyBack, uids : Array ) : void ;

    function getSellList_async( __cb : AMI_IShop_getSellList) : void ;
}
}

