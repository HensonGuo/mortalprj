// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Command{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class ECmdBroadCast
{
    public var __value : int;

    public static const _ECmdBroadcastEntityInfo : int = 1;
    public static const _ECmdBroadcastEntityInfos : int = 2;
    public static const _ECmdBroadcastEntityMoveInfo : int = 3;
    public static const _ECmdBroadcastEntityLeftInfo : int = 4;
    public static const _ECmdBroadcastEntityAttributeUpdate : int = 5;
    public static const _ECmdBroadcastEntityAttributeUpdates : int = 6;
    public static const _ECmdBroadcastEntityLeftInfos : int = 7;
    public static const _ECmdBroadcastEntityFlashInfo : int = 8;
    public static const _ECmdBroadcastEntityOwner : int = 9;
    public static const _ECmdBroadcastEntityDiversion : int = 10;
    public static const _ECmdBroadcastDropEntityInfos : int = 11;
    public static const _ECmdBroadcastDropEntityInfo : int = 12;
    public static const _ECmdBroadcastEntityJump : int = 13;
    public static const _ECmdBroadcastEntitySomersault : int = 14;
    public static const _ECmdBroadcastEntityJumpPoint : int = 15;
    public static const _ECmdBroadcastEntityJumpCutPoint : int = 16;
    public static const _ECmdBroadcastEntityStop : int = 17;
    public static const _ECmdBroadcastMapEntity : int = 21;
    public static const _ECmdBroadcastMapEntityPoint : int = 22;
    public static const _ECmdBroadcastMapEntityLeft : int = 23;
    public static const _ECmdBroadcastMapSharp : int = 24;
    public static const _ECmdBroadcastMapBossEntityPoint : int = 25;
    public static const _ECmdBroadcastEntityBeginFight : int = 41;
    public static const _ECmdBroadcastEntityDoFight : int = 42;
    public static const _ECmdBroadcastEntityFightBack : int = 43;
    public static const _ECmdBroadcastEntityBeginCollect : int = 44;
    public static const _ECmdBroadcastEntityToEntityUpdate : int = 45;
    public static const _ECmdBroadcastEntityGroupUpdate : int = 46;
    public static const _ECmdBroadcastEntityDoFights : int = 47;
    public static const _ECmdBroadcastEntitySkillCast : int = 48;
    public static const _ECmdBroadcastEntityGroupIdUpdate : int = 80;
    public static const _ECmdBroadcastEntityGuildIdUpdate : int = 86;

    public static function convert( val : int ) : ECmdBroadCast
    {
        return new ECmdBroadCast( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECmdBroadCast( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ECmdBroadCast
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 87)
        {
            throw new MarshalException();
        }
        return ECmdBroadCast.convert(__v);
    }
}
}
