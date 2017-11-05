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



public class EBuffType
{
    public var __value : int;

    public static const _EBuffTypeLastDamage : int = 1;
    public static const _EBuffTypeConfused : int = 2;
    public static const _EBuffTypeSleepy : int = 3;
    public static const _EBuffTypeDizzy : int = 4;
    public static const _EBuffTypeMock : int = 5;
    public static const _EBuffTypeHoldStill : int = 6;
    public static const _EBuffTypeFreeze : int = 7;
    public static const _EBuffTypeScared : int = 8;
    public static const _EBuffTypeImmune : int = 9;
    public static const _EBuffTypeInvincible : int = 10;
    public static const _EBuffTypeDamageSuck : int = 11;
    public static const _EBuffTypeDamageRebound : int = 12;
    public static const _EBuffTypeDamageReflex : int = 13;
    public static const _EBuffTypeDamageToCure : int = 14;
    public static const _EBuffTypeAttackReflex : int = 15;
    public static const _EBuffTypeBanSkill : int = 16;
    public static const _EBuffTypeLastCure : int = 17;
    public static const _EBuffTypeLastRecoverBlue : int = 18;
    public static const _EBuffTypeIncOrDeSpeed : int = 19;
    public static const _EBuffTypeIncOrDeCureOut : int = 20;
    public static const _EBuffTypeIncOrDeCureIn : int = 21;
    public static const _EBuffTypeIncOrDeDamageOut : int = 22;
    public static const _EBuffTypeIncOrDeDamageIn : int = 23;
    public static const _EBuffTypeIncOrDeMaxLife : int = 24;
    public static const _EBuffTypeIncOrDeMaxMana : int = 25;
    public static const _EBuffTypeIncOrDeAttack : int = 26;
    public static const _EBuffTypeIncOrDePhysDefense : int = 27;
    public static const _EBuffTypeIncOrDeMagicDefens : int = 28;
    public static const _EBuffTypeIncOrDePenetration : int = 29;
    public static const _EBuffTypeIncOrDeHit : int = 30;
    public static const _EBuffTypeIncOrDeJouk : int = 31;
    public static const _EBuffTypeIncOrDeCrit : int = 32;
    public static const _EBuffTypeIncOrDeTough : int = 33;
    public static const _EBuffTypeIncOrDeExpertise : int = 34;
    public static const _EBuffTypeIncOrDeBlock : int = 35;
    public static const _EBuffTypeIncOrDeDamageReduce : int = 36;
    public static const _EBuffTypeIncOrDeBothDefense : int = 37;
    public static const _EBuffTypeTriggSkill : int = 38;
    public static const _EBuffTypeSuckBlood : int = 39;
    public static const _EBuffTypeFightBack : int = 40;
    public static const _EBuffTypeHalo : int = 41;
    public static const _EBuffTypeBoZang : int = 42;
    public static const _EBuffTypeIncOrDeThreat : int = 43;
    public static const _EBuffTypeDelaySkill : int = 44;
    public static const _EBuffTypeAttackedRebuff : int = 45;
    public static const _EBuffTypeBanAttack : int = 46;
    public static const _EBuffTypeIncOrDeDrugRecover : int = 47;
    public static const _EBuffTypeLastSuckBlood : int = 48;
    public static const _EBuffTypeAttackTriggSkill : int = 49;
    public static const _EBuffTypeLifeDownDie : int = 50;
    public static const _EBuffTypeDisappear : int = 51;
    public static const _EBuffTypeIncOrDeMagicShield : int = 52;
    public static const _EBuffTypeIncOrDeExceptionTime : int = 53;

    public static function convert( val : int ) : EBuffType
    {
        return new EBuffType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EBuffType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EBuffType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 54)
        {
            throw new MarshalException();
        }
        return EBuffType.convert(__v);
    }
}
}
