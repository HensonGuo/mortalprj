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



public class EFightRoleAttribute
{
    public var __value : int;

    public static const _EFightRoleAttributeSpeed : int = 0;
    public static const _EFightRoleAttributeAttack : int = 1;
    public static const _EFightRoleAttributeMaxLife : int = 2;
    public static const _EFightRoleAttributeMaxMana : int = 3;
    public static const _EFightRoleAttributePhysDefense : int = 4;
    public static const _EFightRoleAttributeMagicDefense : int = 5;
    public static const _EFightRoleAttributePenetration : int = 6;
    public static const _EFightRoleAttributeJouk : int = 7;
    public static const _EFightRoleAttributeHit : int = 8;
    public static const _EFightRoleAttributeCrit : int = 9;
    public static const _EFightRoleAttributeToughness : int = 10;
    public static const _EFightRoleAttributeBlock : int = 11;
    public static const _EFightRoleAttributeExpertise : int = 12;
    public static const _EFightRoleAttributeDamageReduce : int = 13;
    public static const _EFightRoleAttributeCrush : int = 14;

    public static function convert( val : int ) : EFightRoleAttribute
    {
        return new EFightRoleAttribute( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EFightRoleAttribute( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EFightRoleAttribute
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 15)
        {
            throw new MarshalException();
        }
        return EFightRoleAttribute.convert(__v);
    }
}
}
