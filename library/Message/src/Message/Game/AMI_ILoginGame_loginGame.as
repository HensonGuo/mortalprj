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



public class AMI_ILoginGame_loginGame extends RMIObject
{
    public function AMI_ILoginGame_loginGame(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "loginGame";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var loginGameReturn : SLoginGameReturn;
        try
        {
            loginGameReturn = new SLoginGameReturn();
            loginGameReturn.__read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(loginGameReturn);
    }

    public function cdeResponse(loginGameReturn : SLoginGameReturn ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , loginGameReturn );
        }
    }
}
}
