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



public class ESkillUpdateType
{
    public var __value : int;

    public static const _ESkillUpdateTypeAdd : int = 1;
    public static const _ESkillUpdateTypeUpgrade : int = 2;
    public static const _ESkillUpdateTypeUpdate : int = 3;
    public static const _ESkillUpdateTypeRemove : int = 4;

    public static function convert( val : int ) : ESkillUpdateType
    {
        return new ESkillUpdateType( val );
    }

    public function value() : int
    {
        return __value;
    }

    public function ESkillUpdateType( val : int )
    {
        __value = val;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ESkillUpdateType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 5)
        {
            throw new MarshalException();
        }
        return ESkillUpdateType.convert(__v);
    }
}
}
