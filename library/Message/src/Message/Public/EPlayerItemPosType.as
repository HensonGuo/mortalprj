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



public class EPlayerItemPosType
{
    public var __value : int;

    public static const _EPlayerItemPosTypeBag : int = 0;
    public static const _EPlayerItemPosTypeWarehouse : int = 1;
    public static const _EPlayerItemPosTypeGMGift : int = 2;
    public static const _EPlayerItemPosTypeRole : int = 3;
    public static const _EPlayerItemPosTypeTask : int = 4;
    public static const _EPlayerItemPosTypeGem : int = 5;
    public static const _EPlayerItemPosTypePet : int = 6;
    public static const _EPlayerItemPosTypeEmbed : int = 7;

    public static function convert( val : int ) : EPlayerItemPosType
    {
        return new EPlayerItemPosType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EPlayerItemPosType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EPlayerItemPosType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 8)
        {
            throw new MarshalException();
        }
        return EPlayerItemPosType.convert(__v);
    }
}
}
