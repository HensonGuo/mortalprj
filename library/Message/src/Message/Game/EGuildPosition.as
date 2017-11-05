// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class EGuildPosition
{
    public var __value : int;

    public static const _EGuildNotMember : int = 0;
    public static const _EGuildBranchMember : int = 1;
    public static const _EGuildMember : int = 2;
    public static const _EGuildElite : int = 3;
    public static const _EGuildLaw : int = 4;
    public static const _EGuildPresbyter : int = 5;
    public static const _EGuildDeputyLeader : int = 6;
    public static const _EGuildLeader : int = 7;

    public static function convert( val : int ) : EGuildPosition
    {
        return new EGuildPosition( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function EGuildPosition( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : EGuildPosition
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 8)
        {
            throw new MarshalException();
        }
        return EGuildPosition.convert(__v);
    }
}
}
