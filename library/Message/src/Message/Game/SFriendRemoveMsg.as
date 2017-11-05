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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SFriendRemoveMsg extends IMessageBase 
{
    public var fromPlayerId : int;

    public var fromPlayerName : String;

    public var toPlayerId : int;

    public var flag : int;

    public function SFriendRemoveMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFriendRemoveMsg = new SFriendRemoveMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15114;

    override public function clone() : IMessageBase
    {
        return new SFriendRemoveMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(fromPlayerId);
        __os.writeString(fromPlayerName);
        __os.writeInt(toPlayerId);
        __os.writeInt(flag);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        fromPlayerId = __is.readInt();
        fromPlayerName = __is.readString();
        toPlayerId = __is.readInt();
        flag = __is.readInt();
    }
}
}
