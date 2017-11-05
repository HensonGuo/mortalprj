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



public class ESkillTriggType
{
    public var __value : int;

    public static const _ESkillTriggActive : int = 0;
    public static const _ESkillTriggBeAttack : int = 1;
    public static const _ESkillTriggAttack : int = 2;
    public static const _ESkillTriggLife : int = 3;
    public static const _ESkillTriggDead : int = 4;
    public static const _ESkillTriggBorn : int = 5;
    public static const _ESkillTriggSummon : int = 6;
    public static const _ESkillTriggXp : int = 7;
    public static const _ESkillTriggAttackSwitch : int = 9;

    public static function convert( val : int ) : ESkillTriggType
    {
        return new ESkillTriggType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ESkillTriggType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ESkillTriggType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 10)
        {
            throw new MarshalException();
        }
        return ESkillTriggType.convert(__v);
    }
}
}
