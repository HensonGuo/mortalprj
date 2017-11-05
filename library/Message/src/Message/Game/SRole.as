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


public class SRole extends IMessageBase 
{
    public var level : int;

    public var experience : Number;

    public var career : int;

    public var careerSecond : int;

    public var life : int;

    public var mana : int;

    public function SRole(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SRole = new SRole( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15002;

    override public function clone() : IMessageBase
    {
        return new SRole;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(level);
        __os.writeLong(experience);
        __os.writeInt(career);
        __os.writeInt(careerSecond);
        __os.writeInt(life);
        __os.writeInt(mana);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        level = __is.readInt();
        experience = __is.readLong();
        career = __is.readInt();
        careerSecond = __is.readInt();
        life = __is.readInt();
        mana = __is.readInt();
    }
}
}
