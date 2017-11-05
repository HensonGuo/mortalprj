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



public class IFightPrxHelper extends RMIProxyObject implements IFightPrx
{
    
    public static const NAME:String = "Message.Game.IFight";

    
    public function IFightPrxHelper()
    {
        name = "IFight";
    }

    public function collect_async( __cb : AMI_IFight_collect, entityId : SEntityId , begin : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "collect" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        __os.writeBool(begin);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dispelBuffSelf_async( __cb : AMI_IFight_dispelBuffSelf) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dispelBuffSelf" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function fight_async( __cb : AMI_IFight_fight, fightOper : SFightOper ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "fight" );
        var __os : SerializeStream = new SerializeStream();
        fightOper.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setFightMode_async( __cb : AMI_IFight_setFightMode, mode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setFightMode" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(mode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

