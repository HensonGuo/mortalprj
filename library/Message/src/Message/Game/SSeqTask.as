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


public class SSeqTask extends IMessageBase 
{
    [ArrayElementType("STask")]
    public var tasks : Array;

    public function SSeqTask(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqTask = new SSeqTask( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16001;

    override public function clone() : IMessageBase
    {
        return new SSeqTask;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqTaskHelper.write(__os, tasks);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        tasks = SeqTaskHelper.read(__is);
    }
}
}

