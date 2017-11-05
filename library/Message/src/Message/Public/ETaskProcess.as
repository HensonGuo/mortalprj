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



public class ETaskProcess
{
    public var __value : int;

    public static const _ETaskProcessDialog : int = 1;
    public static const _ETaskProcessKill : int = 2;
    public static const _ETaskProcessDrop : int = 3;
    public static const _ETaskProcessCollect : int = 4;
    public static const _ETaskProcessDeliver : int = 5;
    public static const _ETaskProcessEscort : int = 6;
    public static const _ETaskProcessIntroduce : int = 7;
    public static const _ETaskProcessTreasure : int = 8;
    public static const _ETaskProcessExplore : int = 9;
    public static const _ETaskProcessDrama : int = 10;

    public static function convert( val : int ) : ETaskProcess
    {
        return new ETaskProcess( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ETaskProcess( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ETaskProcess
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 11)
        {
            throw new MarshalException();
        }
        return ETaskProcess.convert(__v);
    }
}
}
