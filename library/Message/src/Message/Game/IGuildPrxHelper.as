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



public class IGuildPrxHelper extends RMIProxyObject implements IGuildPrx
{
    
    public static const NAME:String = "Message.Game.IGuild";

    
    public function IGuildPrxHelper()
    {
        name = "IGuild";
    }

    public function antiImpeach_async( __cb : AMI_IGuild_antiImpeach) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "antiImpeach" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function applyGuild_async( __cb : AMI_IGuild_applyGuild, playerId : int , guildId : int , type : EApplyGuildType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "applyGuild" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(guildId);
        type.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function applyGuildWarehouse_async( __cb : AMI_IGuild_applyGuildWarehouse, uid : String , amount : int , donateMoney : Dictionary ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "applyGuildWarehouse" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        __os.writeInt(amount);
        DictIntIntHelper.write(__os, donateMoney);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function applyPlayersGuild_async( __cb : AMI_IGuild_applyPlayersGuild, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "applyPlayersGuild" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function cancelApply_async( __cb : AMI_IGuild_cancelApply, guildId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "cancelApply" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(guildId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function cancelApplyGuildWarehouse_async( __cb : AMI_IGuild_cancelApplyGuildWarehouse, uid : String , donateMoney : Dictionary ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "cancelApplyGuildWarehouse" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(uid);
        DictIntIntHelper.write(__os, donateMoney);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeGuildPurpose_async( __cb : AMI_IGuild_changeGuildPurpose, playerId : int , purpose : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeGuildPurpose" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeString(purpose);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changePlayerGuildData_async( __cb : AMI_IGuild_changePlayerGuildData, type : int , value : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changePlayerGuildData" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(type);
        __os.writeInt(value);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function changeYYQQ_async( __cb : AMI_IGuild_changeYYQQ, option : EOperOption , number : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "changeYYQQ" );
        var __os : SerializeStream = new SerializeStream();
        option.__write(__os);
        __os.writeString(number);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function createBranchGuild_async( __cb : AMI_IGuild_createBranchGuild) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "createBranchGuild" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function createGuild_async( __cb : AMI_IGuild_createGuild, playerId : int , mode : ECreate , name : String , purpose : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "createGuild" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        mode.__write(__os);
        __os.writeString(name);
        __os.writeString(purpose);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dealApply_async( __cb : AMI_IGuild_dealApply, fromPlayerId : int , toPlayerId : int , oper : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dealApply" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(fromPlayerId);
        __os.writeInt(toPlayerId);
        __os.writeBool(oper);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dealGuildWarehouseApply_async( __cb : AMI_IGuild_dealGuildWarehouseApply, opr : Boolean , toPlayerId : int , uid : String , applyMoney : Dictionary ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dealGuildWarehouseApply" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeBool(opr);
        __os.writeInt(toPlayerId);
        __os.writeString(uid);
        DictIntIntHelper.write(__os, applyMoney);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function dealInvite_async( __cb : AMI_IGuild_dealInvite, playerId : int , guildId : int , oper : Boolean , mode : EInviteMode ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "dealInvite" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(guildId);
        __os.writeBool(oper);
        mode.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function disbandGuild_async( __cb : AMI_IGuild_disbandGuild) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "disbandGuild" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function exitGuild_async( __cb : AMI_IGuild_exitGuild, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "exitGuild" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getApplyList_async( __cb : AMI_IGuild_getApplyList, guildId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getApplyList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(guildId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getExcellentMemberList_async( __cb : AMI_IGuild_getExcellentMemberList, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getExcellentMemberList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildInfo_async( __cb : AMI_IGuild_getGuildInfo, guild : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildInfo" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(guild);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildList_async( __cb : AMI_IGuild_getGuildList, playerId : int , startIndex : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(startIndex);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildPlayerInfo_async( __cb : AMI_IGuild_getGuildPlayerInfo, guildId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildPlayerInfo" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(guildId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildWarehouse_async( __cb : AMI_IGuild_getGuildWarehouse) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildWarehouse" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildWarehouseApplys_async( __cb : AMI_IGuild_getGuildWarehouseApplys) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildWarehouseApplys" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getGuildWarehouseRecord_async( __cb : AMI_IGuild_getGuildWarehouseRecord) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getGuildWarehouseRecord" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getImpeachStatus_async( __cb : AMI_IGuild_getImpeachStatus) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getImpeachStatus" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function getWarningMemberList_async( __cb : AMI_IGuild_getWarningMemberList, playerId : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "getWarningMemberList" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function guildMail_async( __cb : AMI_IGuild_guildMail, title : String , content : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "guildMail" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(title);
        __os.writeString(content);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function guildRecruit_async( __cb : AMI_IGuild_guildRecruit) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "guildRecruit" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function guildWarehouseOper_async( __cb : AMI_IGuild_guildWarehouseOper, oper : EGuildWarehouseOper , item : SPlayerItem , oprMoney : Dictionary ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "guildWarehouseOper" );
        var __os : SerializeStream = new SerializeStream();
        oper.__write(__os);
        item.__write(__os);
        DictIntIntHelper.write(__os, oprMoney);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function guildWelcome_async( __cb : AMI_IGuild_guildWelcome, option : EOperOption , toPlayerName : String , extend : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "guildWelcome" );
        var __os : SerializeStream = new SerializeStream();
        option.__write(__os);
        __os.writeString(toPlayerName);
        __os.writeInt(extend);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function impeachGuildLeader_async( __cb : AMI_IGuild_impeachGuildLeader) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "impeachGuildLeader" );
        var __os : SerializeStream = new SerializeStream();
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function invitePlayer_async( __cb : AMI_IGuild_invitePlayer, fromPlayerId : int , toPlayerId : int , mode : EInviteMode ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "invitePlayer" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(fromPlayerId);
        __os.writeInt(toPlayerId);
        mode.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function memberOper_async( __cb : AMI_IGuild_memberOper, fromPlayerId : int , toPlayerId : int , toPosition : EGuildPosition ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "memberOper" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(fromPlayerId);
        __os.writeInt(toPlayerId);
        toPosition.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function searchGuilds_async( __cb : AMI_IGuild_searchGuilds, camp : int , guildName : String , startIdx : int , isFull : Boolean ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "searchGuilds" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(camp);
        __os.writeString(guildName);
        __os.writeInt(startIdx);
        __os.writeBool(isFull);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setExcellentCondition_async( __cb : AMI_IGuild_setExcellentCondition, playerId : int , days : int , chatTimes : int , contributionWeek : int , levelRank : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setExcellentCondition" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(days);
        __os.writeInt(chatTimes);
        __os.writeInt(contributionWeek);
        __os.writeInt(levelRank);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function setWarningCondition_async( __cb : AMI_IGuild_setWarningCondition, playerId : int , days : int , activity : int , chatTimes : int , contributionWeek : int ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "setWarningCondition" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeInt(playerId);
        __os.writeInt(days);
        __os.writeInt(activity);
        __os.writeInt(chatTimes);
        __os.writeInt(contributionWeek);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateGuild_async( __cb : AMI_IGuild_updateGuild, type : EUpgradeGuildType ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateGuild" );
        var __os : SerializeStream = new SerializeStream();
        type.__write(__os);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updateGuildName_async( __cb : AMI_IGuild_updateGuildName, newGuildName : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updateGuildName" );
        var __os : SerializeStream = new SerializeStream();
        __os.writeString(newGuildName);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }

    public function updatePlayerGuildData_async( __cb : AMI_IGuild_updatePlayerGuildData, updateType : EUpdateType , attribute : EEntityAttribute , val : int , code : int , logDetailStr : String ) : void 
    {
        var __context : Context = makeContext( session );
        var __call : SRMICall = makeCall( "updatePlayerGuildData" );
        var __os : SerializeStream = new SerializeStream();
        updateType.__write(__os);
        attribute.__write(__os);
        __os.writeInt(val);
        __os.writeInt(code);
        __os.writeString(logDetailStr);
        Outgoing.invokeAsync( __context , __call , __os , __cb );
    }
}
}

