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


public class SPos extends IMessageBase 
{
    public var map : int;

    public var subMap : int;

    public var x : int;

    public var y : int;

    public function SPos(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPos = new SPos( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15031;

    override public function clone() : IMessageBase
    {
        return new SPos;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(map);
        __os.writeInt(subMap);
        __os.writeInt(x);
        __os.writeInt(y);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        map = __is.readInt();
        subMap = __is.readInt();
        x = __is.readInt();
        y = __is.readInt();
    }
}
}
