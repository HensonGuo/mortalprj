// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class EEntityAttribute
{
    public var __value : int;

    public static const _EAttributeGateChannelId : int = 0;
    public static const _EAttributeServerId : int = 1;
    public static const _EAttributeCellId : int = 2;
    public static const _EAttributePlayerId : int = 3;
    public static const _EAttributeUsername : int = 4;
    public static const _EAttributeSpaceId : int = 5;
    public static const _EAttributePointX : int = 6;
    public static const _EAttributePointY : int = 7;
    public static const _EAttributeLevel : int = 8;
    public static const _EAttributeCareer : int = 9;
    public static const _EAttributeExperience : int = 10;
    public static const _EAttributeExperienceAdd : int = 11;
    public static const _EAttributeExperienceDel : int = 12;
    public static const _EAttributeOnlineTime : int = 13;
    public static const _EAttributeSpeed : int = 14;
    public static const _EAttributeCombat : int = 15;
    public static const _EAttributeSoulExp : int = 16;
    public static const _EAttributeDirection : int = 17;
    public static const _EAttributeCamp : int = 18;
    public static const _EAttributeForce : int = 19;
    public static const _EAttributeGuildPosition : int = 20;
    public static const _EAttributeGuildName : int = 21;
    public static const _EAttributeCoin : int = 50;
    public static const _EAttributeCoinBind : int = 51;
    public static const _EAttributeGold : int = 52;
    public static const _EAttributeGoldBind : int = 53;
    public static const _EAttributeVitalEnergy : int = 54;
    public static const _EAttributeFightEnergy : int = 55;
    public static const _EAttributeRunicPower : int = 56;
    public static const _EAttributeFriendIntimate : int = 60;
    public static const _EAttributePlayerSignature : int = 61;
    public static const _EAttributeGroupMemberOnline : int = 70;
    public static const _EAttributeGroupMemberAlive : int = 71;
    public static const _EAttributeGroupMemberMap : int = 72;
    public static const _EAttributeGroupMemberAttacked : int = 73;
    public static const _EAttributePetState : int = 200;
    public static const _EAttributePetLifespan : int = 201;
    public static const _EAttributePetGrowth : int = 202;
    public static const _EAttributePetBlood : int = 203;
    public static const _EAttributePetBloodExp : int = 204;
    public static const _EAttributePetBloodAdd : int = 205;
    public static const _EAttributePetName : int = 206;
    public static const _EAttributePetTalent : int = 207;
    public static const _EAttributePetGrowthMax : int = 208;
    public static const _EAttributePetGrowthMaxGold : int = 209;
    public static const _EAttributeMountTool : int = 260;
    public static const _EAttributeMountState : int = 261;
    public static const _EAttributeMountToolExp : int = 262;
    public static const _EAttributeMountExpNum : int = 263;
    public static const _EAttributeMount : int = 264;
    public static const _EAttributeFighting : int = 300;
    public static const _EAttributeAttackType : int = 301;
    public static const _EAttributeAttackSkill : int = 302;
    public static const _EAttributeHurt : int = 303;
    public static const _EAttributeHurtType : int = 304;
    public static const _EAttributeLife : int = 305;
    public static const _EAttributeLifeAdd : int = 306;
    public static const _EAttributeMana : int = 307;
    public static const _EAttributeManaAdd : int = 308;
    public static const _EAttributeCombo : int = 309;
    public static const _EAttributeStamina : int = 310;
    public static const _EAttributeMaxLife : int = 311;
    public static const _EAttributeMaxMana : int = 312;
    public static const _EAttributeBuff : int = 313;
    public static const _EAttributeJumpCutPointX : int = 314;
    public static const _EAttributeJumpCutPointY : int = 315;
    public static const _EAttributeFightMode : int = 316;
    public static const _EAttributeHurtSuck : int = 317;
    public static const _EAttributeRushForwardPointX : int = 318;
    public static const _EAttributeRushForwardPointY : int = 319;
    public static const _EAttributeUseTime : int = 320;
    public static const _EAttributeLeadTime : int = 321;
    public static const _EAttributeSkillCd : int = 322;
    public static const _EAttributeManaHurt : int = 323;
    public static const _EAttributeHurtReflex : int = 324;
    public static const _EAttributeHurtToCure : int = 325;
    public static const _EAttributeImmune : int = 326;
    public static const _EAttributeHurtRebound : int = 327;
    public static const _EAttributeStatus : int = 328;
    public static const _EAttributeHurtPlusMinus : int = 329;
    public static const _EAttributeDropItem : int = 400;
    public static const _EAttributeDropPickItem : int = 401;
    public static const _EAttributeDropExp : int = 402;
    public static const _EAttributeDropCoin : int = 403;
    public static const _EAttributeDropCoinBind : int = 404;
    public static const _EAttributeDropGold : int = 405;
    public static const _EAttributeDropGoldBind : int = 406;
    public static const _EAttributeDropBossDead : int = 407;
    public static const _EAttributeWeapon : int = 450;
    public static const _EAttributeClothes : int = 451;
    public static const _EAttributeMax : int = 30000;

    public static function convert( val : int ) : EEntityAttribute
    {
        return new EEntityAttribute( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EEntityAttribute( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EEntityAttribute
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 30001)
        {
            throw new MarshalException();
        }
        return EEntityAttribute.convert(__v);
    }
}
}
