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



public class ITestPrxHelper extends RMIProxyObject implements ITestPrx
{
    
    public static const NAME:String = "Message.Game.ITest";

    
    public function ITestPrxHelper()
    {
        name = "ITest";
    }

    public function addBuff_async( __cb : AMI_ITest_addBuff, buffId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addBuff" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(buffId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function addExperience_async( __cb : AMI_ITest_addExperience, type : EEntityType , experience : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addExperience" );
        var __os : SerializeStream = new SerializeStream();
        type.__write(__os);
        __os.writeInt(experience);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function addItem_async( __cb : AMI_ITest_addItem, itemCode : int , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function addLifeOrMana_async( __cb : AMI_ITest_addLifeOrMana, entityType : EEntityType , type : int , value : int , uid : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addLifeOrMana" );
        var __os : SerializeStream = new SerializeStream();
        entityType.__write(__os);
        __os.writeInt(type);
        __os.writeInt(value);
        __os.writeString(uid);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function addMoney_async( __cb : AMI_ITest_addMoney, unit : int , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "addMoney" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(unit);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeCamp_async( __cb : AMI_ITest_changeCamp, camp : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeCamp" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(camp);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeGuildData_async( __cb : AMI_ITest_changeGuildData, type : int , value : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeGuildData" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        __os.writeInt(value);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function clearBag_async( __cb : AMI_ITest_clearBag) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "clearBag" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function clearBoss_async( __cb : AMI_ITest_clearBoss, bossCode : int , entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "clearBoss" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(bossCode);
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function clearMount_async( __cb : AMI_ITest_clearMount) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "clearMount" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function completeTask_async( __cb : AMI_ITest_completeTask, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "completeTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function createBoss_async( __cb : AMI_ITest_createBoss, bossCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "createBoss" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(bossCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function endTask_async( __cb : AMI_ITest_endTask, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "endTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getTask_async( __cb : AMI_ITest_getTask, taskCode : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getTask" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(taskCode);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getThreatList_async( __cb : AMI_ITest_getThreatList, entityId : SEntityId ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getThreatList" );
        var __os : SerializeStream = new SerializeStream();
        entityId.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function openPetBlood_async( __cb : AMI_ITest_openPetBlood, petUid : String , blood : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "openPetBlood" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(petUid);
        __os.writeInt(blood);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function passMap_async( __cb : AMI_ITest_passMap, mapId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "passMap" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(mapId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function rechargeGold_async( __cb : AMI_ITest_rechargeGold, amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "rechargeGold" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function reloadConfigData_async( __cb : AMI_ITest_reloadConfigData) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "reloadConfigData" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function test_async( __cb : AMI_ITest_test) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "test" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateCreateDt_async( __cb : AMI_ITest_updateCreateDt, createDt : Date ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateCreateDt" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeDate(createDt);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateIssm_async( __cb : AMI_ITest_updateIssm, issm : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateIssm" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(issm);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateLevel_async( __cb : AMI_ITest_updateLevel, type : EEntityType , level : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateLevel" );
        var __os : SerializeStream = new SerializeStream();
        type.__write(__os);
        __os.writeInt(level);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateOnlineTime_async( __cb : AMI_ITest_updateOnlineTime, onlineMins : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateOnlineTime" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(onlineMins);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function useItem_async( __cb : AMI_ITest_useItem, itemCode : int , amount : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "useItem" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

