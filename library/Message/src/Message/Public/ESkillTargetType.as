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



public class ESkillTargetType
{
    public var __value : int;

    public static const _ESkillTargetTypeSelf : int = 1;
    public static const _ESkillTargetTypeFriend : int = 2;
    public static const _ESkillTargetTypeEnemy : int = 4;
    public static const _ESkillTargetTypeMaster : int = 8;
    public static const _ESkillTargetTypeDeadBodySelf : int = 16;
    public static const _ESkillTargetTypeDeadBodyFriend : int = 32;
    public static const _ESkillTargetTypeDeadBodyEnemy : int = 64;

    public static function convert( val : int ) : ESkillTargetType
    {
        return new ESkillTargetType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ESkillTargetType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ESkillTargetType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 65)
        {
            throw new MarshalException();
        }
        return ESkillTargetType.convert(__v);
    }
}
}
