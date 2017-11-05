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



public interface IRolePrx 
{
    function learnSkill_async( __cb : AMI_IRole_learnSkill, skillId : int , isDebug : Boolean ) : void ;

    function upgradeSkill_async( __cb : AMI_IRole_upgradeSkill, oldSkillId : int , isDebug : Boolean ) : void ;

    function saveClientSetting_async( __cb : AMI_IRole_saveClientSetting, type : int , jsStr : String ) : void ;

    function dress_async( __cb : AMI_IRole_dress, putonUid : String , getoffUid : String ) : void ;

    function useDrugBag_async( __cb : AMI_IRole_useDrugBag, type : int , uid : String ) : void ;

    function activeRune_async( __cb : AMI_IRole_activeRune, runeId : int , isDebug : Boolean ) : void ;

    function upgradeRune_async( __cb : AMI_IRole_upgradeRune, oldRuneId : int , isDebug : Boolean ) : void ;
}
}
