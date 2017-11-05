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



public class ESkillType
{
    public var __value : int;

    public static const _ESkillTypeDirectDamage : int = 1;
    public static const _ESkillTypeCombo : int = 2;
    public static const _ESkillTypeSplitDamage : int = 3;
    public static const _ESkillTypeCure : int = 4;
    public static const _ESkillTypeRecoverBlue : int = 5;
    public static const _ESkillTypeSuckBlood : int = 6;
    public static const _ESkillTypeSuckBlue : int = 7;
    public static const _ESkillTypeBurnBlue : int = 8;
    public static const _ESkillTypeBeatBack : int = 9;
    public static const _ESkillTypeRushForward : int = 10;
    public static const _ESkillTypePull : int = 11;
    public static const _ESkillTypeTransfer : int = 12;
    public static const _ESkillTypeAddBuff : int = 13;
    public static const _ESkillTypeSelfDestruction : int = 14;
    public static const _ESkillTypeCheatDeath : int = 15;
    public static const _ESkillTypeSnipe : int = 16;
    public static const _ESkillTypeRemoveSelfException : int = 17;
    public static const _ESkillTypeDispel : int = 18;
    public static const _ESkillTypeSummonByPlan : int = 19;
    public static const _ESkillTypeRelive : int = 20;
    public static const _ESkillTypeCopyBody : int = 21;
    public static const _ESkillTypeChangeBody : int = 22;
    public static const _ESkillTypeBanSkill : int = 23;
    public static const _ESkillTypeTrap : int = 24;
    public static const _ESkillTypeHalo : int = 25;
    public static const _ESkillTypeBlackCurtain : int = 26;
    public static const _ESkillTypeCareerFeature : int = 27;
    public static const _ESkillTypeBaseAttack : int = 28;
    public static const _ESkillTypeStateSwitch : int = 29;
    public static const _ESkillTypeAvgLife : int = 30;
    public static const _ESkillTypeSummonBoss : int = 31;
    public static const _ESkillTypeChainDamage : int = 32;
    public static const _ESkillTypeUnion : int = 33;
    public static const _ESkillTypeCouple : int = 34;
    public static const _ESkillTypeChaosAttack : int = 35;
    public static const _ESKillTypeJumpCut : int = 36;
    public static const _ESKillTypeMagicShield : int = 37;
    public static const _ESKillTypeTornado : int = 38;
    public static const _ESKillTypeSummonPet : int = 99;

    public static function convert( val : int ) : ESkillType
    {
        return new ESkillType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ESkillType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ESkillType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 100)
        {
            throw new MarshalException();
        }
        return ESkillType.convert(__v);
    }
}
}
