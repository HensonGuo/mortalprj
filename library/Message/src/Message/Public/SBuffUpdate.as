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


public class SBuffUpdate extends IMessageBase 
{
    public var op : int;

    [ArrayElementType("SBuff")]
    public var buffs : Array;

    public var toId : SEntityId;

    public function SBuffUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBuffUpdate = new SBuffUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2006;

    override public function clone() : IMessageBase
    {
        return new SBuffUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(op);
        SeqBuffHelper.write(__os, buffs);
        toId.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        op = __is.readInt();
        buffs = SeqBuffHelper.read(__is);
        toId = new SEntityId();
        toId.__read(__is);
    }
}
}

