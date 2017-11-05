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



public class EBossType
{
    public var __value : int;

    public static const _EBossTypeNomarl : int = 0;
    public static const _EBossTypeTrap : int = 1;
    public static const _EBossTypeSwitch : int = 2;
    public static const _EBossTypeMachine : int = 3;
    public static const _EBossTypePassageFight : int = 4;
    public static const _EBossTypeBarrierFight : int = 5;
    public static const _EBossTypeEscortFight : int = 6;
    public static const _EBossTypeNpc : int = 20;
    public static const _EBossTypeCollect : int = 21;
    public static const _EBossTypePassage : int = 22;
    public static const _EBossTypeBarrier : int = 23;
    public static const _EBossTypeTouch : int = 24;
    public static const _EBossTypeEscort : int = 25;
    public static const _EBossTypeQuestion : int = 26;
    public static const _EBossTypeFlower : int = 27;

    public static function convert( val : int ) : EBossType
    {
        return new EBossType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EBossType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EBossType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 28)
        {
            throw new MarshalException();
        }
        return EBossType.convert(__v);
    }
}
}
