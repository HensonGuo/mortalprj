// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.BroadCast{

import Message.BroadCast.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqEntityUpdate extends IMessageBase 
{
    [ArrayElementType("SEntityUpdate")]
    public var entityUpdates : Array;

    public function SSeqEntityUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqEntityUpdate = new SSeqEntityUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 11007;

    override public function clone() : IMessageBase
    {
        return new SSeqEntityUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqEntityUpdateHelper.write(__os, entityUpdates);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityUpdates = SeqEntityUpdateHelper.read(__is);
    }
}
}

