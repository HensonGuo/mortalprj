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



public class ILoginGamePrxHelper extends RMIProxyObject implements ILoginGamePrx
{
    
    public static const NAME:String = "Message.Game.ILoginGame";

    
    public function ILoginGamePrxHelper()
    {
        name = "ILoginGame";
    }

    public function loginGame_async( __cb : AMI_ILoginGame_loginGame, playerId : int , username : String , name : String , loginId : Number , sessionStr : String , version : String , fromAddress : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "loginGame" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeString(username);
        __os.writeString(name);
        __os.writeLong(loginId);
        __os.writeString(sessionStr);
        __os.writeString(version);
        __os.writeString(fromAddress);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
