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



public class AMI_IGuild_getGuildWarehouse extends RMIObject
{
    public function AMI_IGuild_getGuildWarehouse(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "getGuildWarehouse";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var warehouseItems : Array;
        var moneyMap : Dictionary;
        try
        {
            warehouseItems = SeqPlayerItemHelper.read(__is);
            moneyMap = DictIntIntHelper.read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(warehouseItems, moneyMap);
    }

    public function cdeResponse(warehouseItems : Array , moneyMap : Dictionary ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , warehouseItems , moneyMap );
        }
    }
}
}

