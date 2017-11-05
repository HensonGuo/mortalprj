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


public class SInviteInfo extends IMessageBase 
{
    public var guildName : String;

    public var fromPlayerId : int;

    public var toPlayerId : int;

    public function SInviteInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SInviteInfo = new SInviteInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15201;

    override public function clone() : IMessageBase
    {
        return new SInviteInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(guildName);
        __os.writeInt(fromPlayerId);
        __os.writeInt(toPlayerId);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        guildName = __is.readString();
        fromPlayerId = __is.readInt();
        toPlayerId = __is.readInt();
    }
}
}
