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


public class SNpcTaskMsg extends IMessageBase 
{
    [ArrayElementType("SNpcTask")]
    public var npcTasks : Array;

    public function SNpcTaskMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SNpcTaskMsg = new SNpcTaskMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16005;

    override public function clone() : IMessageBase
    {
        return new SNpcTaskMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqNpcTaskHelper.write(__os, npcTasks);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        npcTasks = SeqNpcTaskHelper.read(__is);
    }
}
}

