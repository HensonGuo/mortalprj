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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMiniPlayer extends IMessageBase 
{
    public var entityId : SEntityId;

    public var name : String;

    public var sex : int;

    public var career : int;

    public var camp : int;

    public var level : int;

    public var VIP : int;

    public var online : Boolean;

    public var signature : String;

    public var combat : int;

    public function SMiniPlayer(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SMiniPlayer = new SMiniPlayer( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 82;

    override public function clone() : IMessageBase
    {
        return new SMiniPlayer;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        __os.writeString(name);
        __os.writeByte(sex);
        __os.writeShort(career);
        __os.writeByte(camp);
        __os.writeByte(level);
        __os.writeByte(VIP);
        __os.writeBool(online);
        __os.writeString(signature);
        __os.writeInt(combat);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        name = __is.readString();
        sex = __is.readByte();
        career = __is.readShort();
        camp = __is.readByte();
        level = __is.readByte();
        VIP = __is.readByte();
        online = __is.readBool();
        signature = __is.readString();
        combat = __is.readInt();
    }
}
}
