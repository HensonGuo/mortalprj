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


public class SFriendReplyMsg extends IMessageBase 
{
    public var apply : SMiniPlayer;

    public var reply : SMiniPlayer;

    public var toPlayerId : int;

    public var result : int;

    public var type : int;

    public function SFriendReplyMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFriendReplyMsg = new SFriendReplyMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15113;

    override public function clone() : IMessageBase
    {
        return new SFriendReplyMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        apply.__write(__os);
        reply.__write(__os);
        __os.writeInt(toPlayerId);
        __os.writeInt(result);
        __os.writeInt(type);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        apply = new SMiniPlayer();
        apply.__read(__is);
        reply = new SMiniPlayer();
        reply.__read(__is);
        toPlayerId = __is.readInt();
        result = __is.readInt();
        type = __is.readInt();
    }
}
}

