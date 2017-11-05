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


public class SFriendApplyMsg extends IMessageBase 
{
    public var apply : SMiniPlayer;

    public var toPlayerName : String;

    public var type : int;

    public function SFriendApplyMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFriendApplyMsg = new SFriendApplyMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15111;

    override public function clone() : IMessageBase
    {
        return new SFriendApplyMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        apply.__write(__os);
        __os.writeString(toPlayerName);
        __os.writeInt(type);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        apply = new SMiniPlayer();
        apply.__read(__is);
        toPlayerName = __is.readString();
        type = __is.readInt();
    }
}
}

