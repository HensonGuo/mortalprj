// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Login{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class AMI_ILogin_createFirstRole extends RMIObject
{
    public function AMI_ILogin_createFirstRole(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "createFirstRole";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var sReturn : SLoginReturn;
        try
        {
            sReturn = new SLoginReturn();
            sReturn.__read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(sReturn);
    }

    public function cdeResponse(sReturn : SLoginReturn ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , sReturn );
        }
    }
}
}
