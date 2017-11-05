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



public class IPetPrxHelper extends RMIProxyObject implements IPetPrx
{
    
    public static const NAME:String = "Message.Game.IPet";

    
    public function IPetPrxHelper()
    {
        name = "IPet";
    }

    public function addLifespan_async( __cb : AMI_IPet_addLifespan, petUid : String , str : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addLifespan" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        SeqStringHelper.write(__os, str);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function calAttribute_async( __cb : AMI_IPet_calAttribute, petUid : String , talent : int , growth : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "calAttribute" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(talent);
        __os.writeInt(growth);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getBlood_async( __cb : AMI_IPet_getBlood) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getBlood" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getPetInfo_async( __cb : AMI_IPet_getPetInfo, playerId : int , uids : Array ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getPetInfo" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        SeqStringHelper.write(__os, uids);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getPlayerPetInfo_async( __cb : AMI_IPet_getPlayerPetInfo) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getPlayerPetInfo" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getRandPetSkill_async( __cb : AMI_IPet_getRandPetSkill, itemUid : String , itemCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getRandPetSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(itemUid);
        __os.writeInt(itemCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function learnSkill_async( __cb : AMI_IPet_learnSkill, petUid : String , skillBookUid : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "learnSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeString(skillBookUid);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function randPetSkill_async( __cb : AMI_IPet_randPetSkill, itemUid : String , time : int , isBind : Boolean , isFree : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "randPetSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(itemUid);
        __os.writeInt(time);
        __os.writeBool(isBind);
        __os.writeBool(isFree);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function refreshGrowth_async( __cb : AMI_IPet_refreshGrowth, petUid : String , autoBuy : Boolean , count : int , target : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "refreshGrowth" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeBool(autoBuy);
        __os.writeInt(count);
        __os.writeInt(target);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function sealPetSkill_async( __cb : AMI_IPet_sealPetSkill, petUid : String , skillId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "sealPetSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(skillId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setName_async( __cb : AMI_IPet_setName, uid : String , name : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setName" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeString(name);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setPetMode_async( __cb : AMI_IPet_setPetMode, uid : String , mode : EPetMode ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setPetMode" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        mode.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setPetState_async( __cb : AMI_IPet_setPetState, uid : String , state : EPetState ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setPetState" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        state.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function unsealPetSkill_async( __cb : AMI_IPet_unsealPetSkill, petUid : String , fromPos : int , toPos : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "unsealPetSkill" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(fromPos);
        __os.writeInt(toPos);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateSkillPos_async( __cb : AMI_IPet_updateSkillPos, petUid : String , skillId : int , pos : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateSkillPos" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(skillId);
        __os.writeInt(pos);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeBlood_async( __cb : AMI_IPet_upgradeBlood, petUid : String , blood : int , count : int , autoBuy : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeBlood" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(blood);
        __os.writeInt(count);
        __os.writeBool(autoBuy);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function upgradeTalent_async( __cb : AMI_IPet_upgradeTalent, petUid : String , items : Dictionary , quickBuy : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "upgradeTalent" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        DictStrIntHelper.write(__os, items);
        __os.writeBool(quickBuy);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

