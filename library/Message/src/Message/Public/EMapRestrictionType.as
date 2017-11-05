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



public class EMapRestrictionType
{
    public var __value : int;

    public static const _EMapRestrictionTypeSave : int = 1;
    public static const _EMapRestrictionTypePK : int = 2;
    public static const _EMapRestrictionTypeGroup : int = 4;
    public static const _EMapRestrictionTypePass : int = 8;
    public static const _EMapRestrictionTypeMount : int = 16;
    public static const _EMapRestrictionTypePet : int = 32;
    public static const _EMapRestrictionTypeTransform : int = 64;
    public static const _EMapRestrictionTypeFight : int = 128;
    public static const _EMapRestrictionTypeFly : int = 256;
    public static const _EMapRestrictionTypeSomersault : int = 512;

    public static function convert( val : int ) : EMapRestrictionType
    {
        return new EMapRestrictionType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EMapRestrictionType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EMapRestrictionType
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 513)
        {
            throw new MarshalException();
        }
        return EMapRestrictionType.convert(__v);
    }
}
}
