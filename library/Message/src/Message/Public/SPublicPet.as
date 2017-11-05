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


public class SPublicPet extends IMessageBase 
{
    public var entityId : SEntityId;

    public var ownerEntityId : SEntityId;

    public var uid : String;

    public var name : String;

    public var specialName : String;

    public var type : int;

    public var level : int;

    public var code : int;

    public var model : int;

    public var life : int;

    public var mana : int;

    public var needLevel : int;

    public var experience : Number;

    public var lifeSpan : int;

    public var maxLifeSpan : int;

    public var combatCapabilities : int;

    public var growth : int;

    public var growthMax : int;

    public var talent : int;

    public var talentMax : int;

    public var blood : String;

    public var state : int;

    public var fightMode : int;

    public var skillIds : Dictionary;

    public var lastDeadDt : Date;

    public function SPublicPet(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicPet = new SPublicPet( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 83;

    override public function clone() : IMessageBase
    {
        return new SPublicPet;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        ownerEntityId.__write(__os);
        __os.writeString(uid);
        __os.writeString(name);
        __os.writeString(specialName);
        __os.writeByte(type);
        __os.writeByte(level);
        __os.writeInt(code);
        __os.writeInt(model);
        __os.writeInt(life);
        __os.writeInt(mana);
        __os.writeByte(needLevel);
        __os.writeLong(experience);
        __os.writeInt(lifeSpan);
        __os.writeInt(maxLifeSpan);
        __os.writeInt(combatCapabilities);
        __os.writeByte(growth);
        __os.writeByte(growthMax);
        __os.writeShort(talent);
        __os.writeShort(talentMax);
        __os.writeString(blood);
        __os.writeByte(state);
        __os.writeByte(fightMode);
        DictIntIntHelper.write(__os, skillIds);
        __os.writeDate(lastDeadDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        ownerEntityId = new SEntityId();
        ownerEntityId.__read(__is);
        uid = __is.readString();
        name = __is.readString();
        specialName = __is.readString();
        type = __is.readByte();
        level = __is.readByte();
        code = __is.readInt();
        model = __is.readInt();
        life = __is.readInt();
        mana = __is.readInt();
        needLevel = __is.readByte();
        experience = __is.readLong();
        lifeSpan = __is.readInt();
        maxLifeSpan = __is.readInt();
        combatCapabilities = __is.readInt();
        growth = __is.readByte();
        growthMax = __is.readByte();
        talent = __is.readShort();
        talentMax = __is.readShort();
        blood = __is.readString();
        state = __is.readByte();
        fightMode = __is.readByte();
        skillIds = DictIntIntHelper.read(__is);
        lastDeadDt = __is.readDate();
    }
}
}
