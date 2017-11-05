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



public class EMapPointType
{
    public var __value : int;

    public static const _EMapPointNoActive : int = 0;
    public static const _EMapPointCanFly : int = 1;
    public static const _EMapPointCanJump : int = 2;
    public static const _EMapPointCanAttack : int = 3;
    public static const _EMapPointCanWalk : int = 4;
    public static const _EMapPointTransparent : int = 6;
    public static const _EMapPointSwin : int = 7;
    public static const _EMapPointBusiness : int = 8;
    public static const _EMapPointMeditation : int = 9;
    public static const _EMapPointFish : int = 10;
    public static const _EMapPointSafe : int = 11;
    public static const _EMapPointSafeServer : int = 12;
    public static const _EMapPointSafeRevivalA : int = 13;
    public static const _EMapPointSafeRevivalB : int = 14;
    public static const _EMapPointSafeRevivalC : int = 15;
    public static const _EMapPointSafeRevivalPub : int = 16;
    public static const _EMapPointRevivalA : int = 19;
    public static const _EMapPointRevivalB : int = 20;
    public static const _EMapPointRevivalC : int = 21;
    public static const _EMapPointRevivalPub : int = 22;

    public static function convert( val : int ) : EMapPointType
    {
        return new EMapPointType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMapPointType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EMapPointType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 23)
        {
            throw new MarshalException();
        }
        return EMapPointType.convert(__v);
    }
}
}
