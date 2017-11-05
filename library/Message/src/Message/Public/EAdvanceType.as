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



public class EAdvanceType
{
    public var __value : int;

    public static const _EAdvanceTypePlayer : int = 0;
    public static const _EAdvanceTypePet : int = 1;
    public static const _EAdvanceStrengthTone : int = 2;
    public static const _EAdvanceRefreshTone : int = 3;
    public static const _EAdvanceRefreshLock : int = 4;
    public static const _EAdvanceTypeJewelMarrow : int = 6;
    public static const _EAdvanceTypePetGrowth : int = 12;
    public static const _EAdvanceTypePetBlood : int = 13;
    public static const _EAdvanceTypeMountUp : int = 14;
    public static const _EAdvanceTypeMountTool : int = 15;
    public static const _EAdvanceTypeRune : int = 16;
    public static const _EAdvanceTypePetTalent : int = 17;

    public static function convert( val : int ) : EAdvanceType
    {
        return new EAdvanceType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EAdvanceType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EAdvanceType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 18)
        {
            throw new MarshalException();
        }
        return EAdvanceType.convert(__v);
    }
}
}
