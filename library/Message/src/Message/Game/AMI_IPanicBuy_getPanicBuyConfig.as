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



public class AMI_IPanicBuy_getPanicBuyConfig extends RMIObject
{
    public function AMI_IPanicBuy_getPanicBuyConfig(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "getPanicBuyConfig";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var refreshMsg : SPanicBuyMsg;
        try
        {
            refreshMsg = new SPanicBuyMsg();
            refreshMsg.__read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(refreshMsg);
    }

    public function cdeResponse(refreshMsg : SPanicBuyMsg ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , refreshMsg );
        }
    }
}
}
