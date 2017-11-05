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



public class EJewelType
{
    public var __value : int;

    public static const _EJewelTypeAttack : int = 1;
    public static const _EJewelTypeLife : int = 2;
    public static const _EJewelTypeMagic : int = 3;
    public static const _EJewelTypePhysicalDefense : int = 4;
    public static const _EJewelTypeMagicDefense : int = 5;
    public static const _EJewelTypePenetration : int = 6;
    public static const _EJewelTypeJouk : int = 7;
    public static const _EJewelTypeHit : int = 8;
    public static const _EJewelTypeCrit : int = 9;
    public static const _EJewelTypeToughness : int = 10;
    public static const _EJewelTypeBlock : int = 11;
    public static const _EJewelTypeExpertise : int = 12;

    public static function convert( val : int ) : EJewelType
    {
        return new EJewelType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EJewelType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EJewelType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 13)
        {
            throw new MarshalException();
        }
        return EJewelType.convert(__v);
    }
}
}
