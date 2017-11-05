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

import Message.Game.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqPlayerTaskUpdate extends IMessageBase 
{
    [ArrayElementType("SPlayerTaskUpdate")]
    public var updates : Array;

    public function SSeqPlayerTaskUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqPlayerTaskUpdate = new SSeqPlayerTaskUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16000;

    override public function clone() : IMessageBase
    {
        return new SSeqPlayerTaskUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqPlayerTaskUpdateHelper.write(__os, updates);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updates = SeqPlayerTaskUpdateHelper.read(__is);
    }
}
}

