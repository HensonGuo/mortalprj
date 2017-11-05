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



public class EAIPath
{
    public var __value : int;

    public static const _EAIPathNo : int = 0;
    public static const _EAIPathOneStraight : int = 1;
    public static const _EAIPathLoopStraight : int = 2;
    public static const _EAIPathOneRandom : int = 3;
    public static const _EAIPathLoopRandom : int = 4;

    public static function convert( val : int ) : EAIPath
    {
        return new EAIPath( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EAIPath( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EAIPath
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 5)
        {
            throw new MarshalException();
        }
        return EAIPath.convert(__v);
    }
}
}
