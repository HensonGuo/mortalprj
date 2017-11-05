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



public class ECmdCell
{
    public var __value : int;

    public static const _ECmdCellToAllGateTest : int = 30000;
    public static const _ECmdCellToGateTest : int = 30001;
    public static const _ECmdCellEntityMove : int = 30011;
    public static const _ECmdCellEntityDiversion : int = 30012;
    public static const _ECmdCellEntityStop : int = 30013;
    public static const _ECmdCellEntityLeft : int = 30014;
    public static const _ECmdCellEntityFlash : int = 30015;
    public static const _ECmdCellEntityJump : int = 30016;
    public static const _ECmdCellEntitySomersault : int = 30017;
    public static const _ECmdCellEntityJumpPoint : int = 30018;
    public static const _ECmdCellEntityRevival : int = 30021;
    public static const _ECmdCellEntityRevivalSitu : int = 30022;
    public static const _ECmdCellEntityBossDead : int = 30023;
    public static const _ECmdCellEntityAttributeUpdate : int = 30051;
    public static const _ECmdCellEntityBuffUpdate : int = 30052;
    public static const _ECmdCellEntitySelfDispelBuff : int = 30053;
    public static const _ECmdCellEntityRemoveTypeBuff : int = 30054;
    public static const _ECmdCellToEntityBuffUpdate : int = 30055;
    public static const _ECmdCellFightTo : int = 30071;
    public static const _ECmdCellActivePet : int = 30072;
    public static const _ECmdCellPetEntityAttributeUpdate : int = 30101;
    public static const _ECmdCellEntityGroupInfo : int = 30151;
    public static const _ECmdCellEntityGuildInfo : int = 30161;

    public static function convert( val : int ) : ECmdCell
    {
        return new ECmdCell( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ECmdCell( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : ECmdCell
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 30162)
        {
            throw new MarshalException();
        }
        return ECmdCell.convert(__v);
    }
}
}
