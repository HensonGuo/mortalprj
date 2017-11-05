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



public class ERuneEffectType
{
    public var __value : int;

    public static const _ERuneEffectSkillDistance : int = 1;
    public static const _ERuneEffectSkillRange : int = 2;
    public static const _ERuneEffectSkillTriggRate : int = 3;
    public static const _ERuneEffectSkillHitRate : int = 4;
    public static const _ERuneEffectSkillUseTime : int = 5;
    public static const _ERuneEffectSkillHurtEffect : int = 6;
    public static const _ERuneEffectSkillAddBuffRate : int = 7;
    public static const _ERuneEffectSkillCooldownTime : int = 8;
    public static const _ERuneEffectSkillExtraBuff : int = 9;
    public static const _ERuneEffectSkillSpecialEffect : int = 10;
    public static const _ERuneEffectSkillCopyBodyAttack : int = 11;
    public static const _ERuneEffectSkillLeadSkillCount : int = 12;
    public static const _ERuneEffectBuffTriggRate : int = 20;
    public static const _ERuneEffectBuffEffectAdd : int = 21;
    public static const _ERuneEffectBuffEffectMult : int = 22;
    public static const _ERuneEffectBuffLastTime : int = 23;
    public static const _ERuneEffectBuffOverLay : int = 24;
    public static const _ERuneEffectSkillSummonBossLive : int = 40;

    public static function convert( val : int ) : ERuneEffectType
    {
        return new ERuneEffectType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ERuneEffectType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ERuneEffectType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 41)
        {
            throw new MarshalException();
        }
        return ERuneEffectType.convert(__v);
    }
}
}
