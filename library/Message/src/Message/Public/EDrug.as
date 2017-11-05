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



public class EDrug
{
    public var __value : int;

    public static const _EDrugLife : int = 0;
    public static const _EDrugMana : int = 1;
    public static const _EDrugLifeBag : int = 2;
    public static const _EDrugManaBag : int = 3;
    public static const _EDrugLifeInstant : int = 4;
    public static const _EDrugManaInstant : int = 5;
    public static const _EDrugMoreExp : int = 6;
    public static const _EDrugExp : int = 7;
    public static const _EDrugBuff : int = 8;
    public static const _EDrugState : int = 9;
    public static const _EDrugPetLifespan : int = 10;
    public static const _EDrugFixBuff : int = 11;
    public static const _EDrugPetLife : int = 12;
    public static const _EDrugPetLifeBag : int = 13;

    public static function convert( val : int ) : EDrug
    {
        return new EDrug( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EDrug( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EDrug
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 14)
        {
            throw new MarshalException();
        }
        return EDrug.convert(__v);
    }
}
}
