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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SFightOper extends IMessageBase 
{
    [ArrayElementType("SEntityId")]
    public var toEntitys : Array;

    public var skillId : int;

    public var mousePoint : SPoint;

    public var op : int;

    public var count : int;

    public var uid : String;

    public function SFightOper(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFightOper = new SFightOper( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15950;

    override public function clone() : IMessageBase
    {
        return new SFightOper;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqEntityIdHelper.write(__os, toEntitys);
        __os.writeInt(skillId);
        mousePoint.__write(__os);
        __os.writeInt(op);
        __os.writeInt(count);
        __os.writeString(uid);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        toEntitys = SeqEntityIdHelper.read(__is);
        skillId = __is.readInt();
        mousePoint = new SPoint();
        mousePoint.__read(__is);
        op = __is.readInt();
        count = __is.readInt();
        uid = __is.readString();
    }
}
}

