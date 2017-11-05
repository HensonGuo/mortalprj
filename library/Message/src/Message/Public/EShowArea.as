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



public class EShowArea
{
    public var __value : int;

    public static const _EShowAreaChat : int = 1;
    public static const _EShowAreaMiddle : int = 2;
    public static const _EShowAreaMiddleTop : int = 4;
    public static const _EShowAreaHistory : int = 8;
    public static const _EShowAreaTrumpet : int = 16;
    public static const _EShowAreaExplorer : int = 32;
    public static const _EShowAreaRightDown : int = 64;
    public static const _EShowAreaMiddleDown : int = 128;
    public static const _EShowAreaActiveExplorer : int = 256;
    public static const _EShowAreaMiddleDownEx : int = 512;
    public static const _EShowAreaRollShow : int = 1024;

    public static function convert( val : int ) : EShowArea
    {
        return new EShowArea( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EShowArea( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort( __value );
    }

    public static function __read( __is : SerializeStream ) : EShowArea
    {
        var __v : int = __is.readShort();
        if(__v < 0 || __v >= 1025)
        {
            throw new MarshalException();
        }
        return EShowArea.convert(__v);
    }
}
}
