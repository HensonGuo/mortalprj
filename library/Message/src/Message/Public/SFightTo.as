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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SFightTo extends IMessageBase 
{
    public var op : int;

    public var code : int;

    public var mousePoint : SPoint;

    [ArrayElementType("SEntityId")]
    public var entityIds : Array;

    public function SFightTo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFightTo = new SFightTo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 51;

    override public function clone() : IMessageBase
    {
        return new SFightTo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(op);
        __os.writeInt(code);
        mousePoint.__write(__os);
        SeqEntityIdHelper.write(__os, entityIds);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        op = __is.readInt();
        code = __is.readInt();
        mousePoint = new SPoint();
        mousePoint.__read(__is);
        entityIds = SeqEntityIdHelper.read(__is);
    }
}
}

