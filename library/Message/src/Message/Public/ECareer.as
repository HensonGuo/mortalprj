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



public class ECareer
{
    public var __value : int;

    public static const _ECareerNo : int = 0;
    public static const _ECareerWarrior : int = 1;
    public static const _ECareerArcher : int = 2;
    public static const _ECareerMage : int = 4;
    public static const _ECareerPriest : int = 8;
    public static const _ECareerWarriorEx : int = 16;
    public static const _ECareerArcherEx : int = 32;
    public static const _ECareerMageEx : int = 64;
    public static const _ECareerPriestEx : int = 128;
    public static const _ECareerPhysPet : int = 256;
    public static const _ECareerMagicPet : int = 512;

    public static function convert( val : int ) : ECareer
    {
        return new ECareer( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECareer( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : ECareer
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 513)
        {
            throw new MarshalException();
        }
        return ECareer.convert(__v);
    }
}
}
