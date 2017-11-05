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



public interface ITestPrx 
{
    function test_async( __cb : AMI_ITest_test) : void ;

    function updateCreateDt_async( __cb : AMI_ITest_updateCreateDt, createDt : Date ) : void ;

    function addMoney_async( __cb : AMI_ITest_addMoney, unit : int , amount : int ) : void ;

    function addExperience_async( __cb : AMI_ITest_addExperience, type : EEntityType , experience : int ) : void ;

    function updateLevel_async( __cb : AMI_ITest_updateLevel, type : EEntityType , level : int ) : void ;

    function addItem_async( __cb : AMI_ITest_addItem, itemCode : int , amount : int ) : void ;

    function useItem_async( __cb : AMI_ITest_useItem, itemCode : int , amount : int ) : void ;

    function addLifeOrMana_async( __cb : AMI_ITest_addLifeOrMana, entityType : EEntityType , type : int , value : int , uid : String ) : void ;

    function updateOnlineTime_async( __cb : AMI_ITest_updateOnlineTime, onlineMins : int ) : void ;

    function updateIssm_async( __cb : AMI_ITest_updateIssm, issm : int ) : void ;

    function rechargeGold_async( __cb : AMI_ITest_rechargeGold, amount : int ) : void ;

    function createBoss_async( __cb : AMI_ITest_createBoss, bossCode : int ) : void ;

    function reloadConfigData_async( __cb : AMI_ITest_reloadConfigData) : void ;

    function passMap_async( __cb : AMI_ITest_passMap, mapId : int ) : void ;

    function addBuff_async( __cb : AMI_ITest_addBuff, buffId : int ) : void ;

    function openPetBlood_async( __cb : AMI_ITest_openPetBlood, petUid : String , blood : int ) : void ;

    function clearBoss_async( __cb : AMI_ITest_clearBoss, bossCode : int , entityId : SEntityId ) : void ;

    function getTask_async( __cb : AMI_ITest_getTask, taskCode : int ) : void ;

    function completeTask_async( __cb : AMI_ITest_completeTask, taskCode : int ) : void ;

    function endTask_async( __cb : AMI_ITest_endTask, taskCode : int ) : void ;

    function getThreatList_async( __cb : AMI_ITest_getThreatList, entityId : SEntityId ) : void ;

    function changeCamp_async( __cb : AMI_ITest_changeCamp, camp : int ) : void ;

    function clearBag_async( __cb : AMI_ITest_clearBag) : void ;

    function clearMount_async( __cb : AMI_ITest_clearMount) : void ;

    function changeGuildData_async( __cb : AMI_ITest_changeGuildData, type : int , value : int ) : void ;
}
}

