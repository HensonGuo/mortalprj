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


public class SEntityId extends IMessageBase 
{
    public var type : int;

    public var typeEx : int;

    public var typeEx2 : int;

    public var id : int;

    public function SEntityId(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SEntityId = new SEntityId( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 1;

    override public function clone() : IMessageBase
    {
        return new SEntityId;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte(type);
        __os.writeShort(typeEx);
        __os.writeByte(typeEx2);
        __os.writeInt(id);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readByte();
        typeEx = __is.readShort();
        typeEx2 = __is.readByte();
        id = __is.readInt();
    }
}
}
