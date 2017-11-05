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


public class SOneKeyFriendsInfo extends IMessageBase 
{
    public var playerId : int;

    public var name : String;

    public var entityId : SEntityId;

    public var level : int;

    public var camp : int;

    public var sex : int;

    public function SOneKeyFriendsInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SOneKeyFriendsInfo = new SOneKeyFriendsInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15119;

    override public function clone() : IMessageBase
    {
        return new SOneKeyFriendsInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(name);
        entityId.__write(__os);
        __os.writeByte(level);
        __os.writeByte(camp);
        __os.writeByte(sex);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        name = __is.readString();
        entityId = new SEntityId();
        entityId.__read(__is);
        level = __is.readByte();
        camp = __is.readByte();
        sex = __is.readByte();
    }
}
}

