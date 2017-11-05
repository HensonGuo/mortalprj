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



public class EStepType
{
    public var __value : int;

    public static const _EStepTypeNormal : int = 0;
    public static const _EStepTypeDramaAdd : int = 1;
    public static const _EStepTypeDramaCancel : int = 2;
    public static const _EStepTypeDramaPrint : int = 3;
    public static const _EStepTypeAnimation : int = 4;
    public static const _EStepTypeAnimationEnd : int = 5;
    public static const _EStepTypeAnimationPrint : int = 6;
    public static const _EStepTypeBossDialog : int = 7;
    public static const _EStepTypePetActive : int = 8;
    public static const _EStepTypePetIdle : int = 9;
    public static const _EStepTypeEffect : int = 10;
    public static const _EStepTypeEffectActive : int = 11;
    public static const _EStepTypeEffectDel : int = 12;
    public static const _EStepTypeTaskDramaPrint : int = 13;
    public static const _EStepTypePlayerMoveOnly : int = 14;
    public static const _EStepTypePlayerMoveOnlyDel : int = 15;
    public static const _EStepTypePlayerMoveScreen : int = 16;
    public static const _EStepTypeScreenLock : int = 17;
    public static const _EStepTypeScreenUnlock : int = 18;
    public static const _EStepTypeScreenMove : int = 19;
    public static const _EStepTypeScreenRestore : int = 20;
    public static const _EStepTypePlayerFly : int = 21;
    public static const _EStepTypeMenuShow : int = 22;
    public static const _EStepTypeMenuHide : int = 23;
    public static const _EStepTypeMoviePlay : int = 24;
    public static const _EStepTypeMovieEnd : int = 25;
    public static const _EStepTypeBossActive : int = 26;
    public static const _EStepTypeNpcActive : int = 27;
    public static const _EStepTypeNpcDialog : int = 28;
    public static const _EStepTypeBuffAdd : int = 50;
    public static const _EStepTypeBuffDel : int = 51;
    public static const _EStepTypeBossRefresh : int = 52;
    public static const _EStepTypeBossDel : int = 53;
    public static const _EStepTypeBossMove : int = 54;
    public static const _EStepTypeSkill : int = 55;
    public static const _EStepTypeBossFollow : int = 56;
    public static const _EStepTypeBossFollowDel : int = 57;
    public static const _EStepTypeChangeDirect : int = 58;
    public static const _EStepTypeActiveStop : int = 59;
    public static const _EStepTypeActiveStart : int = 60;
    public static const _EStepTypeFinish : int = 100;

    public static function convert( val : int ) : EStepType
    {
        return new EStepType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EStepType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EStepType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 101)
        {
            throw new MarshalException();
        }
        return EStepType.convert(__v);
    }
}
}
