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



public class ILoginPrxHelper extends RMIProxyObject implements ILoginPrx
{
    
    public static const NAME:String = "Message.Login.ILogin";

    
    public function ILoginPrxHelper()
    {
        name = "ILogin";
    }

    public function createFirstRole_async( __cb : AMI_ILogin_createFirstRole, firstRole : SFirstRole ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "createFirstRole" );
        var __os : SerializeStream = new SerializeStream();
        firstRole.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function login_async( __cb : AMI_ILogin_login, loginS : SLogin ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "login" );
        var __os : SerializeStream = new SerializeStream();
        loginS.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
