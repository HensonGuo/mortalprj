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



public class IMountPrxHelper extends RMIProxyObject implements IMountPrx
{
    
    public static const NAME:String = "Message.Game.IMount";

    
    public function IMountPrxHelper()
    {
        name = "IMount";
    }

    public function getPlayerMountInfo_async( __cb : AMI_IMount_getPlayerMountInfo) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getPlayerMountInfo" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setMountState_async( __cb : AMI_IMount_setMountState, uid : String , state : EMountState ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setMountState" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        state.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgrade_async( __cb : AMI_IMount_upgrade, uid : String , type : int , itemCount : int , goldCount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgrade" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeInt(type);
        __os.writeInt(itemCount);
        __os.writeInt(goldCount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeTool_async( __cb : AMI_IMount_upgradeTool, uid : String , type : int , itemCount : int , goldCount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeTool" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeInt(type);
        __os.writeInt(itemCount);
        __os.writeInt(goldCount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

