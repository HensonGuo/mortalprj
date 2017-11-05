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



public interface IGuildPrx 
{
    function createGuild_async( __cb : AMI_IGuild_createGuild, playerId : int , mode : ECreate , name : String , purpose : String ) : void ;

    function createBranchGuild_async( __cb : AMI_IGuild_createBranchGuild) : void ;

    function changeGuildPurpose_async( __cb : AMI_IGuild_changeGuildPurpose, playerId : int , purpose : String ) : void ;

    function getGuildInfo_async( __cb : AMI_IGuild_getGuildInfo, guild : int ) : void ;

    function searchGuilds_async( __cb : AMI_IGuild_searchGuilds, camp : int , guildName : String , startIdx : int , isFull : Boolean ) : void ;

    function applyGuild_async( __cb : AMI_IGuild_applyGuild, playerId : int , guildId : int , type : EApplyGuildType ) : void ;

    function cancelApply_async( __cb : AMI_IGuild_cancelApply, guildId : int ) : void ;

    function invitePlayer_async( __cb : AMI_IGuild_invitePlayer, fromPlayerId : int , toPlayerId : int , mode : EInviteMode ) : void ;

    function dealApply_async( __cb : AMI_IGuild_dealApply, fromPlayerId : int , toPlayerId : int , oper : Boolean ) : void ;

    function dealInvite_async( __cb : AMI_IGuild_dealInvite, playerId : int , guildId : int , oper : Boolean , mode : EInviteMode ) : void ;

    function memberOper_async( __cb : AMI_IGuild_memberOper, fromPlayerId : int , toPlayerId : int , toPosition : EGuildPosition ) : void ;

    function getApplyList_async( __cb : AMI_IGuild_getApplyList, guildId : int ) : void ;

    function getGuildPlayerInfo_async( __cb : AMI_IGuild_getGuildPlayerInfo, guildId : int ) : void ;

    function disbandGuild_async( __cb : AMI_IGuild_disbandGuild) : void ;

    function applyPlayersGuild_async( __cb : AMI_IGuild_applyPlayersGuild, playerId : int ) : void ;

    function updateGuild_async( __cb : AMI_IGuild_updateGuild, type : EUpgradeGuildType ) : void ;

    function updatePlayerGuildData_async( __cb : AMI_IGuild_updatePlayerGuildData, updateType : EUpdateType , attribute : EEntityAttribute , val : int , code : int , logDetailStr : String ) : void ;

    function changePlayerGuildData_async( __cb : AMI_IGuild_changePlayerGuildData, type : int , value : int ) : void ;

    function changeYYQQ_async( __cb : AMI_IGuild_changeYYQQ, option : EOperOption , number : String ) : void ;

    function guildWelcome_async( __cb : AMI_IGuild_guildWelcome, option : EOperOption , toPlayerName : String , extend : int ) : void ;

    function guildMail_async( __cb : AMI_IGuild_guildMail, title : String , content : String ) : void ;

    function updateGuildName_async( __cb : AMI_IGuild_updateGuildName, newGuildName : String ) : void ;

    function impeachGuildLeader_async( __cb : AMI_IGuild_impeachGuildLeader) : void ;

    function antiImpeach_async( __cb : AMI_IGuild_antiImpeach) : void ;

    function getImpeachStatus_async( __cb : AMI_IGuild_getImpeachStatus) : void ;

    function exitGuild_async( __cb : AMI_IGuild_exitGuild, playerId : int ) : void ;

    function getGuildList_async( __cb : AMI_IGuild_getGuildList, playerId : int , startIndex : int ) : void ;

    function getWarningMemberList_async( __cb : AMI_IGuild_getWarningMemberList, playerId : int ) : void ;

    function getExcellentMemberList_async( __cb : AMI_IGuild_getExcellentMemberList, playerId : int ) : void ;

    function setWarningCondition_async( __cb : AMI_IGuild_setWarningCondition, playerId : int , days : int , activity : int , chatTimes : int , contributionWeek : int ) : void ;

    function setExcellentCondition_async( __cb : AMI_IGuild_setExcellentCondition, playerId : int , days : int , chatTimes : int , contributionWeek : int , levelRank : int ) : void ;

    function guildRecruit_async( __cb : AMI_IGuild_guildRecruit) : void ;

    function getGuildWarehouse_async( __cb : AMI_IGuild_getGuildWarehouse) : void ;

    function applyGuildWarehouse_async( __cb : AMI_IGuild_applyGuildWarehouse, uid : String , amount : int , donateMoney : Dictionary ) : void ;

    function cancelApplyGuildWarehouse_async( __cb : AMI_IGuild_cancelApplyGuildWarehouse, uid : String , donateMoney : Dictionary ) : void ;

    function dealGuildWarehouseApply_async( __cb : AMI_IGuild_dealGuildWarehouseApply, opr : Boolean , toPlayerId : int , uid : String , applyMoney : Dictionary ) : void ;

    function guildWarehouseOper_async( __cb : AMI_IGuild_guildWarehouseOper, oper : EGuildWarehouseOper , item : SPlayerItem , oprMoney : Dictionary ) : void ;

    function getGuildWarehouseApplys_async( __cb : AMI_IGuild_getGuildWarehouseApplys) : void ;

    function getGuildWarehouseRecord_async( __cb : AMI_IGuild_getGuildWarehouseRecord) : void ;
}
}

