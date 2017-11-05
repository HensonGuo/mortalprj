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



public class ETaskGroup
{
    public var __value : int;

    public static const _ETaskGroupMain : int = 1;
    public static const _ETaskGroupBranch : int = 2;
    public static const _ETaskGroupLoop : int = 3;
    public static const _ETaskGroupEscort : int = 4;
    public static const _ETaskGroupAlliance : int = 5;
    public static const _ETaskGroupTreasure : int = 6;
    public static const _ETaskGroupCopy : int = 7;
    public static const _ETaskGroupRomance : int = 8;
    public static const _ETaskGroupSpy : int = 9;
    public static const _ETaskGroupCross : int = 10;

    public static function convert( val : int ) : ETaskGroup
    {
        return new ETaskGroup( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ETaskGroup( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ETaskGroup
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 11)
        {
            throw new MarshalException();
        }
        return ETaskGroup.convert(__v);
    }
}
}
