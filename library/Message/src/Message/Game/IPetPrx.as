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



public interface IPetPrx 
{
    function getPlayerPetInfo_async( __cb : AMI_IPet_getPlayerPetInfo) : void ;

    function setPetState_async( __cb : AMI_IPet_setPetState, uid : String , state : EPetState ) : void ;

    function setPetMode_async( __cb : AMI_IPet_setPetMode, uid : String , mode : EPetMode ) : void ;

    function setName_async( __cb : AMI_IPet_setName, uid : String , name : String ) : void ;

    function getPetInfo_async( __cb : AMI_IPet_getPetInfo, playerId : int , uids : Array ) : void ;

    function addLifespan_async( __cb : AMI_IPet_addLifespan, petUid : String , str : Array ) : void ;

    function refreshGrowth_async( __cb : AMI_IPet_refreshGrowth, petUid : String , autoBuy : Boolean , count : int , target : int ) : void ;

    function getBlood_async( __cb : AMI_IPet_getBlood) : void ;

    function upgradeBlood_async( __cb : AMI_IPet_upgradeBlood, petUid : String , blood : int , count : int , autoBuy : Boolean ) : void ;

    function upgradeTalent_async( __cb : AMI_IPet_upgradeTalent, petUid : String , items : Dictionary , quickBuy : Boolean ) : void ;

    function calAttribute_async( __cb : AMI_IPet_calAttribute, petUid : String , talent : int , growth : int ) : void ;

    function learnSkill_async( __cb : AMI_IPet_learnSkill, petUid : String , skillBookUid : String ) : void ;

    function updateSkillPos_async( __cb : AMI_IPet_updateSkillPos, petUid : String , skillId : int , pos : int ) : void ;

    function sealPetSkill_async( __cb : AMI_IPet_sealPetSkill, petUid : String , skillId : int ) : void ;

    function unsealPetSkill_async( __cb : AMI_IPet_unsealPetSkill, petUid : String , fromPos : int , toPos : int ) : void ;

    function randPetSkill_async( __cb : AMI_IPet_randPetSkill, itemUid : String , time : int , isBind : Boolean , isFree : Boolean ) : void ;

    function getRandPetSkill_async( __cb : AMI_IPet_getRandPetSkill, itemUid : String , itemCode : int ) : void ;
}
}

