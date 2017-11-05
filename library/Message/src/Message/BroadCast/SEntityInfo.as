// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.BroadCast{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SEntityInfo extends IMessageBase 
{
    public var entityId : SEntityId;

    public var ownerEntityId : SEntityId;

    public var name : String;

    public var code : int;

    public var life : int;

    public var maxLife : int;

    public var mana : int;

    public var maxMana : int;

    public var camp : int;

    public var force : int;

    public var sex : int;

    public var career : int;

    public var VIP : int;

    public var level : int;

    public var status : int;

    public var fighting : Boolean;

    public var fightMode : int;

    public var speed : int;

    public var direction : int;

    public var avatar : int;

    public var model : int;

    public var talent : int;

    public var growth : int;

    public var mountCode : int;

    public var combat : int;

    public var guildName : String;

    public var guildPosition : int;

    public var entityShows : Dictionary;

    public var reserveJs : String;

    [ArrayElementType("SPoint")]
    public var points : Array;

    [ArrayElementType("int")]
    public var buffs : Array;

    public var groupId : SEntityId;

    public var guildId : SEntityId;

    public function SEntityInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SEntityInfo = new SEntityInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 11003;

    override public function clone() : IMessageBase
    {
        return new SEntityInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        ownerEntityId.__write(__os);
        __os.writeString(name);
        __os.writeInt(code);
        __os.writeInt(life);
        __os.writeInt(maxLife);
        __os.writeInt(mana);
        __os.writeInt(maxMana);
        __os.writeByte(camp);
        __os.writeByte(force);
        __os.writeByte(sex);
        __os.writeShort(career);
        __os.writeByte(VIP);
        __os.writeByte(level);
        __os.writeByte(status);
        __os.writeBool(fighting);
        __os.writeByte(fightMode);
        __os.writeShort(speed);
        __os.writeByte(direction);
        __os.writeInt(avatar);
        __os.writeInt(model);
        __os.writeInt(talent);
        __os.writeInt(growth);
        __os.writeInt(mountCode);
        __os.writeInt(combat);
        __os.writeString(guildName);
        __os.writeInt(guildPosition);
        DictIntIntHelper.write(__os, entityShows);
        __os.writeString(reserveJs);
        SeqPointHelper.write(__os, points);
        SeqIntHelper.write(__os, buffs);
        groupId.__write(__os);
        guildId.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        ownerEntityId = new SEntityId();
        ownerEntityId.__read(__is);
        name = __is.readString();
        code = __is.readInt();
        life = __is.readInt();
        maxLife = __is.readInt();
        mana = __is.readInt();
        maxMana = __is.readInt();
        camp = __is.readByte();
        force = __is.readByte();
        sex = __is.readByte();
        career = __is.readShort();
        VIP = __is.readByte();
        level = __is.readByte();
        status = __is.readByte();
        fighting = __is.readBool();
        fightMode = __is.readByte();
        speed = __is.readShort();
        direction = __is.readByte();
        avatar = __is.readInt();
        model = __is.readInt();
        talent = __is.readInt();
        growth = __is.readInt();
        mountCode = __is.readInt();
        combat = __is.readInt();
        guildName = __is.readString();
        guildPosition = __is.readInt();
        entityShows = DictIntIntHelper.read(__is);
        reserveJs = __is.readString();
        points = SeqPointHelper.read(__is);
        buffs = SeqIntHelper.read(__is);
        groupId = new SEntityId();
        groupId.__read(__is);
        guildId = new SEntityId();
        guildId.__read(__is);
    }
}
}

