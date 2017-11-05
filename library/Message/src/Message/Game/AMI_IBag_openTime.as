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



public class AMI_IBag_openTime extends RMIObject
{
    public function AMI_IBag_openTime(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "openTime";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var onlineTime : int;
        var saveTime : int;
        try
        {
            onlineTime = __is.readInt();
            saveTime = __is.readInt();
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(onlineTime, saveTime);
    }

    public function cdeResponse(onlineTime : int , saveTime : int ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , onlineTime , saveTime );
        }
    }
}
}

