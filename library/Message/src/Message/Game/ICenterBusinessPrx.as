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



public interface ICenterBusinessPrx 
{
    function doApply_async( __cb : AMI_ICenterBusiness_doApply, entityId : SEntityId ) : void ;

    function doOperation_async( __cb : AMI_ICenterBusiness_doOperation, oper : EBusinessOperation , businessId : String ) : void ;

    function updateItem_async( __cb : AMI_ICenterBusiness_updateItem, businessId : String , itemId : String , count : int ) : void ;

    function updateMoney_async( __cb : AMI_ICenterBusiness_updateMoney, businessId : String , unit : EPrictUnit , amount : int ) : void ;
}
}

