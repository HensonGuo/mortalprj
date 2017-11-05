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



public class IRolePrxHelper extends RMIProxyObject implements IRolePrx
{
    
    public static const NAME:String = "Message.Game.IRole";

    
    public function IRolePrxHelper()
    {
        name = "IRole";
    }

    public function activeRune_async( __cb : AMI_IRole_activeRune, runeId : int , isDebug : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "activeRune" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(runeId);
        __os.writeBool(isDebug);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dress_async( __cb : AMI_IRole_dress, putonUid : String , getoffUid : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dress" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(putonUid);
        __os.writeString(getoffUid);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function learnSkill_async( __cb : AMI_IRole_learnSkill, skillId : int , isDebug : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "learnSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(skillId);
        __os.writeBool(isDebug);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function saveClientSetting_async( __cb : AMI_IRole_saveClientSetting, type : int , jsStr : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "saveClientSetting" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        __os.writeString(jsStr);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeRune_async( __cb : AMI_IRole_upgradeRune, oldRuneId : int , isDebug : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeRune" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(oldRuneId);
        __os.writeBool(isDebug);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeSkill_async( __cb : AMI_IRole_upgradeSkill, oldSkillId : int , isDebug : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(oldSkillId);
        __os.writeBool(isDebug);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function useDrugBag_async( __cb : AMI_IRole_useDrugBag, type : int , uid : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "useDrugBag" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        __os.writeString(uid);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}
