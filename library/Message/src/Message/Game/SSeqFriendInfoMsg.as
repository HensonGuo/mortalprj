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


public class SSeqFriendInfoMsg extends IMessageBase 
{
    public var fromPlayerId : int;

    [ArrayElementType("SFriendInfoMsg")]
    public var friendInfoMsgs : Array;

    public function SSeqFriendInfoMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqFriendInfoMsg = new SSeqFriendInfoMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15117;

    override public function clone() : IMessageBase
    {
        return new SSeqFriendInfoMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(fromPlayerId);
        SeqFriendInfoMsgHelper.write(__os, friendInfoMsgs);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        fromPlayerId = __is.readInt();
        friendInfoMsgs = SeqFriendInfoMsgHelper.read(__is);
    }
}
}

