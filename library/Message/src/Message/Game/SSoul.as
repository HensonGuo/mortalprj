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


public class SSoul extends IMessageBase 
{
    public var soul : int;

    public var node : int;

    public var level : int;

    public function SSoul(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSoul = new SSoul( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15004;

    override public function clone() : IMessageBase
    {
        return new SSoul;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(soul);
        __os.writeInt(node);
        __os.writeInt(level);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        soul = __is.readInt();
        node = __is.readInt();
        level = __is.readInt();
    }
}
}
