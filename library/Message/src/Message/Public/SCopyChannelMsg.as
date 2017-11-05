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


public class SCopyChannelMsg extends IMessageBase 
{
    [ArrayElementType("SCopyChannel")]
    public var channels : Array;

    public function SCopyChannelMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SCopyChannelMsg = new SCopyChannelMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2;

    override public function clone() : IMessageBase
    {
        return new SCopyChannelMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqCopyChannelHelper.write(__os, channels);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        channels = SeqCopyChannelHelper.read(__is);
    }
}
}

