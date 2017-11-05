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



public class EEquip
{
    public var __value : int;

    public static const _EEquipWeapon : int = 0;
    public static const _EEquipHelmet : int = 1;
    public static const _EEquipShoulder : int = 2;
    public static const _EEquipClothes : int = 3;
    public static const _EEquipWristlet : int = 4;
    public static const _EEquipGlove : int = 5;
    public static const _EEquipBelt : int = 6;
    public static const _EEquipPants : int = 7;
    public static const _EEquipShoe : int = 8;
    public static const _EEquipRing : int = 9;
    public static const _EEquipNecklace : int = 10;
    public static const _EEquipPendant : int = 11;
    public static const _EEquipAmulet : int = 12;
    public static const _EEquipFashion : int = 13;
    public static const _EEquipWing : int = 14;
    public static const _EEquipWeaponFashion : int = 15;
    public static const _EEquipPug : int = 16;

    public static function convert( val : int ) : EEquip
    {
        return new EEquip( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EEquip( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EEquip
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 17)
        {
            throw new MarshalException();
        }
        return EEquip.convert(__v);
    }
}
}
