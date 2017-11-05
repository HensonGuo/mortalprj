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



public class EGateCommand
{
    public var __value : int;

    public static const _ECmdGateToCenterTest : int = 20000;
    public static const _ECmdGateToGateMgrTest : int = 20001;
    public static const _ECmdGatePlayerItemUpdate : int = 20011;
    public static const _ECmdGateBag : int = 20012;
    public static const _ECmdGateDrugCanUseDt : int = 20013;
    public static const _ECmdGateDrugBagInfo : int = 20014;
    public static const _ECmdGateShopBuy : int = 20015;
    public static const _ECmdGatePanicBuyItem : int = 20016;
    public static const _ECmdGatePanicBuyRefresh : int = 20017;
    public static const _ECmdGatePanicBuyPlayer : int = 20018;
    public static const _ECmdGateChatMsgMoniter : int = 20031;
    public static const _ECmdGateChatMsg : int = 20032;
    public static const _ECmdGateOnlineNum : int = 20033;
    public static const _ECmdGateOperationOnline : int = 20034;
    public static const _ECmdGateIssm : int = 20035;
    public static const _ECmdGateUserLocked : int = 20036;
    public static const _ECmdGateMailNotice : int = 20037;
    public static const _ECmdGateBroadcastChatMsg : int = 20038;
    public static const _ECmdGateGuildMsg : int = 20039;
    public static const _ECmdGateRoleUpdate : int = 20051;
    public static const _ECmdGateMoneyUpdate : int = 20052;
    public static const _ECmdGatePositionUpdate : int = 20053;
    public static const _ECmdGateSkillUpdate : int = 20054;
    public static const _ECmdGateSkill : int = 20055;
    public static const _ECmdGateClientSetting : int = 20056;
    public static const _ECmdGateBuffUpdate : int = 20057;
    public static const _ECmdGateFightPetInfo : int = 20058;
    public static const _ECmdGatePetInfo : int = 20059;
    public static const _ECmdGatePetUpdate : int = 20060;
    public static const _ECmdGatePetInfoUpdate : int = 20061;
    public static const _ECmdGateMount : int = 20062;
    public static const _ECmdGateMountUpdate : int = 20063;
    public static const _ECmdGateMountInfo : int = 20064;
    public static const _ECmdGateMountInfoUpdate : int = 20065;
    public static const _ECmdGateRuneUpdate : int = 20066;
    public static const _ECmdGateRune : int = 20067;
    public static const _ECmdGatePetSkillUpdate : int = 20068;
    public static const _ECmdGatePetSkillWarehouse : int = 20069;
    public static const _ECmdGateRoleUpdateFight : int = 20070;
    public static const _ECmdGatePetSkillRandDaily : int = 20071;
    public static const _ECmdGateTaskUpdate : int = 20101;
    public static const _ECmdGateTaskCanGet : int = 20102;
    public static const _ECmdGateTaskMy : int = 20103;
    public static const _ECmdGateTaskRemoveMy : int = 20104;
    public static const _ECmdGateTaskRemoveCanGet : int = 20105;
    public static const _ECmdGateTaskAddMy : int = 20106;
    public static const _ECmdGateTaskAddCanGet : int = 20107;
    public static const _ECmdGateTaskNpcTask : int = 20108;
    public static const _ECmdGateTaskShow : int = 20109;
    public static const _ECmdGateTaskAddEffect : int = 20110;
    public static const _ECmdGateFriendApply : int = 20151;
    public static const _ECmdGateFriendReply : int = 20152;
    public static const _ECmdGateFriendRecord : int = 20153;
    public static const _ECmdGateFriendRemove : int = 20154;
    public static const _ECmdGateFriendInfoUpdate : int = 20155;
    public static const _ECmdGateFriendInfo : int = 20156;
    public static const _ECmdGateFriendOnlineStatus : int = 20157;
    public static const _ECmdGateFriendInfoUpdateToCenter : int = 20158;
    public static const _ECmdGateFriendOnlineStatustoCenter : int = 20159;
    public static const _ECmdGateBuyBack : int = 20201;
    public static const _ECmdGateBuyBackUpdate : int = 20202;
    public static const _ECmdGateStrength : int = 20220;
    public static const _ECmdGateMarketSearch : int = 20251;
    public static const _ECmdGateMarketGetMyRecords : int = 20252;
    public static const _ECmdGateMarketResultBuyItem : int = 20253;
    public static const _ECmdGateMarketResultSellItem : int = 20254;
    public static const _ECmdGateMarketResultCancelSell : int = 20255;
    public static const _ECmdGateMarketResultSeekBuy : int = 20256;
    public static const _ECmdGateMarketResultCancelSeekBuy : int = 20257;
    public static const _ECmdGatePlayerSoulInfo : int = 20301;

    public static function convert( val : int ) : EGateCommand
    {
        return new EGateCommand( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EGateCommand( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EGateCommand
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 20302)
        {
            throw new MarshalException();
        }
        return EGateCommand.convert(__v);
    }
}
}
