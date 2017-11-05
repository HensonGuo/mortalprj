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


public class SFriendInfoMsg extends IMessageBase 
{
    public var fromPlayerId : int;

    public var fromPlayerName : String;

    public var entityId : SEntityId;

    public var toPlayerId : int;

    public var flag : int;

    public var online : Boolean;

    public var fromPlayerLevel : int;

    public var VIP : int;

    public var intimate : int;

    public var avatar : int;

    public var photo : int;

    public var sex : int;

    public function SFriendInfoMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFriendInfoMsg = new SFriendInfoMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15116;

    override public function clone() : IMessageBase
    {
        return new SFriendInfoMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(fromPlayerId);
        __os.writeString(fromPlayerName);
        entityId.__write(__os);
        __os.writeInt(toPlayerId);
        __os.writeInt(flag);
        __os.writeBool(online);
        __os.writeInt(fromPlayerLevel);
        __os.writeByte(VIP);
        __os.writeInt(intimate);
        __os.writeByte(avatar);
        __os.writeInt(photo);
        __os.writeByte(sex);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        fromPlayerId = __is.readInt();
        fromPlayerName = __is.readString();
        entityId = new SEntityId();
        entityId.__read(__is);
        toPlayerId = __is.readInt();
        flag = __is.readInt();
        online = __is.readBool();
        fromPlayerLevel = __is.readInt();
        VIP = __is.readByte();
        intimate = __is.readInt();
        avatar = __is.readByte();
        photo = __is.readInt();
        sex = __is.readByte();
    }
}
}

