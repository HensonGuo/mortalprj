// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Command{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class EPublicCommand
{
    public var __value : int;

    public static const _ECmdPublicErrorMsg : int = 10000;
    public static const _ECmdPublicLoginInfoShow : int = 10001;
    public static const _ECmdPublicNoticeBroadcastMsg : int = 10002;
    public static const _ECmdPublicDispatchMsg : int = 10003;
    public static const _ECmdPublicCopyChannelMsg : int = 10004;
    public static const _ECmdPublicTestCreateBoss : int = 10031;
    public static const _ECmdPublicTestClearBoss : int = 10032;
    public static const _ECmdPublicTestClearBossEntity : int = 10033;
    public static const _ECmdPublicTestBossThreat : int = 10034;
    public static const _ECmdPublicNpcToBoss : int = 10035;
    public static const _ECmdPublicRoleResetPoint : int = 10051;
    public static const _ECmdPublicRoleMoveTo : int = 10052;
    public static const _ECmdPublicRolePoint : int = 10053;
    public static const _ECmdPublicRoleDiversion : int = 10054;
    public static const _ECmdPublicRoleJump : int = 10055;
    public static const _ECmdPublicRoleSomersault : int = 10056;
    public static const _ECmdPublicRoleJumpPoint : int = 10057;
    public static const _ECmdPublicRoleJumpCutPoint : int = 10058;
    public static const _ECmdPublicFightOper : int = 10071;
    public static const _ECmdPublicEntityKillerInfo : int = 10072;
    public static const _ECmdPublicCollectBegin : int = 10073;
    public static const _ECmdPublicCollectEnd : int = 10074;
    public static const _ECmdPublicEntityKillInfo : int = 10075;
    public static const _ECmdPublicFightAttributeBase : int = 10081;
    public static const _ECmdPublicFightAttributeExtra : int = 10082;
    public static const _ECmdPublicFightAttribute : int = 10083;
    public static const _ECmdPublicFightAttributeNotClient : int = 10084;
    public static const _ECmdPublicFightAttributeAddPercent : int = 10085;
    public static const _ECmdPublicNormalDrop : int = 10100;
    public static const _ECmdPublicPickItemDrop : int = 10101;
    public static const _ECmdPublicPickOper : int = 10102;
    public static const _ECmdPublicPetFightAttribute : int = 10111;
    public static const _ECmdPublicPetFightAttributeNotClient : int = 10112;
    public static const _ECmdPublicPetFightAttributeAddPercent : int = 10113;
    public static const _ECmdPublicGroupCreate : int = 10131;
    public static const _ECmdPublicGroupDisband : int = 10132;
    public static const _ECmdPublicGroupOper : int = 10133;
    public static const _ECmdPublicGroupKickOut : int = 10134;
    public static const _ECmdPublicGroupModifyCaptain : int = 10135;
    public static const _ECmdPublicGroupInfo : int = 10136;
    public static const _ECmdPublicGroupLeft : int = 10137;
    public static const _ECmdPublicGroupInfoRequest : int = 10138;
    public static const _ECmdPublicGetGroupInfosBack : int = 10139;
    public static const _ECmdPublicGroupSettingUpdate : int = 10140;
    public static const _ECmdPublicGroupMemberUpdate : int = 10141;
    public static const _ECmdPublicKillBoss : int = 10161;
    public static const _ECmdPublicEscortBoss : int = 10162;
    public static const _ECmdPublicEscortDeath : int = 10163;
    public static const _ECmdPublicEscortSuccess : int = 10164;
    public static const _ECmdPublicDramaStepMsg : int = 10165;
    public static const _ECmdPublicDramaStart : int = 10166;
    public static const _ECmdPublicPlayerCopyInfo : int = 10201;
    public static const _ECmdPublicCopyPassInto : int = 10202;
    public static const _ECmdPublicCopyRePassInto : int = 10203;
    public static const _ECmdPublicCopyLeft : int = 10204;
    public static const _ECmdPublicCopyRoomOper : int = 10205;
    public static const _ECmdPublicWaitingInfo : int = 10206;
    public static const _ECmdPublicGroupCreateCopy : int = 10207;
    public static const _ECmdPublicCopyEnterNum : int = 10208;
    public static const _ECmdPublicCopyGroupCheck : int = 10209;
    public static const _ECmdPublicCopyGroupCheckError : int = 10210;
    public static const _ECmdPublicCopyGroupCheckResponse : int = 10211;
    public static const _ECmdPublicCopyGroupErrorBroadcast : int = 10212;
    public static const _ECmdPublicCopyQuickGroupCheck : int = 10213;
    public static const _ECmdPublicCopyQuickGroupCheckError : int = 10214;
    public static const _ECmdPublicGuildInvite : int = 10250;
    public static const _ECmdPublicGuildImpeach : int = 10251;
    public static const _ECmdPublicGuildLeaderImpeachEnd : int = 10252;
    public static const _ECmdPublicGuildApplyNum : int = 10253;
    public static const _ECmdPublicGuildNewMember : int = 10254;
    public static const _ECmdPublicGuildAttributeUpdate : int = 10255;
    public static const _ECmdPublicGuildKickOut : int = 10256;
    public static const _ECmdPublicPlayerGuildInfoUpdate : int = 10257;
    public static const _ECmdPublicPlayerExitGuild : int = 10258;
    public static const _ECmdPublicGuildMemberInfoUpdate : int = 10259;
    public static const _ECmdPublicJoinGuildResult : int = 10260;
    public static const _ECmdPublicDisbandGuild : int = 10261;
    public static const _ECmdPublicCreateBranchGuild : int = 10262;
    public static const _ECmdPublicWarningMemberNum : int = 10263;
    public static const _ECmdPublicExcellentMemberNum : int = 10264;
    public static const _ECmdPublicInviteCreateGuild : int = 10265;
    public static const _ECmdPublicInviteCreateSuccess : int = 10266;
    public static const _ECmdPublicInviteCreateFail : int = 10267;
    public static const _ECmdPublicGuildWarehouseApplyNum : int = 10268;
    public static const _ECmdPublicGuildWarehouseUpdate : int = 10269;
    public static const _ECmdPublicGuildWarehouseApplyUpdate : int = 10270;
    public static const _ECmdPublicGuildWarehouseAssign : int = 10271;
    public static const _ECmdPublicGuildWarehouseOut : int = 10272;
    public static const _ECmdPublicGuildPositionModify : int = 10273;
    public static const _ECmdPublicBusiness : int = 10351;
    public static const _ECmdPublicBusinessApplySuccessful : int = 10352;
    public static const _ECmdPublicLotteryHistorys : int = 10401;
    public static const _ECmdPublicLotteryHistoryAdd : int = 10402;

    public static function convert( val : int ) : EPublicCommand
    {
        return new EPublicCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EPublicCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EPublicCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 10403)
        {
            throw new MarshalException();
        }
        return EPublicCommand.convert(__v);
    }
}
}
