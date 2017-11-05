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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SFightRole
{
    public var entityId : SEntityId;

    public var ownerEntityId : SEntityId;

    public var groupId : SEntityId;

    public var guildId : SEntityId;

    public var gateChannelId : int;

    public var serverId : int;

    public var cellId : int;

    public var spaceId : int;

    public var point : SPoint;

    public var playerId : int;

    public var username : String;

    public var name : String;

    public var type : int;

    public var roleId : int;

    public var sex : int;

    public var career : int;

    public var level : int;

    public var VIP : int;

    public var camp : int;

    public var force : int;

    public var fightMode : int;

    public var combat : int;

    public var life : int;

    public var mana : int;

    public var stamina : int;

    public var globalCooldown : int;

    public var avatar : int;

    public var model : int;

    public var talent : int;

    public var growth : int;

    public var code : int;

    public var mountCode : int;

    public var guildName : String;

    public var guildPosition : int;

    public var baseFight : SFightAttribute;

    public var extraFight : SFightAttribute;

    public var addPercent : SFightAttributeAddPercent;

    [ArrayElementType("SSkill")]
    public var skills : Array;

    [ArrayElementType("SBuff")]
    public var buffs : Array;

    [ArrayElementType("int")]
    public var runes : Array;

    public var entityShows : Dictionary;

    public function SFightRole()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        ownerEntityId.__write(__os);
        groupId.__write(__os);
        guildId.__write(__os);
        __os.writeInt(gateChannelId);
        __os.writeInt(serverId);
        __os.writeInt(cellId);
        __os.writeInt(spaceId);
        point.__write(__os);
        __os.writeInt(playerId);
        __os.writeString(username);
        __os.writeString(name);
        __os.writeInt(type);
        __os.writeInt(roleId);
        __os.writeInt(sex);
        __os.writeShort(career);
        __os.writeByte(level);
        __os.writeByte(VIP);
        __os.writeByte(camp);
        __os.writeByte(force);
        __os.writeByte(fightMode);
        __os.writeInt(combat);
        __os.writeInt(life);
        __os.writeInt(mana);
        __os.writeInt(stamina);
        __os.writeInt(globalCooldown);
        __os.writeInt(avatar);
        __os.writeInt(model);
        __os.writeInt(talent);
        __os.writeInt(growth);
        __os.writeInt(code);
        __os.writeInt(mountCode);
        __os.writeString(guildName);
        __os.writeInt(guildPosition);
        baseFight.__write(__os);
        extraFight.__write(__os);
        addPercent.__write(__os);
        SeqSkillHelper.write(__os, skills);
        SeqBuffHelper.write(__os, buffs);
        SeqIntHelper.write(__os, runes);
        DictIntIntHelper.write(__os, entityShows);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        ownerEntityId = new SEntityId();
        ownerEntityId.__read(__is);
        groupId = new SEntityId();
        groupId.__read(__is);
        guildId = new SEntityId();
        guildId.__read(__is);
        gateChannelId = __is.readInt();
        serverId = __is.readInt();
        cellId = __is.readInt();
        spaceId = __is.readInt();
        point = new SPoint();
        point.__read(__is);
        playerId = __is.readInt();
        username = __is.readString();
        name = __is.readString();
        type = __is.readInt();
        roleId = __is.readInt();
        sex = __is.readInt();
        career = __is.readShort();
        level = __is.readByte();
        VIP = __is.readByte();
        camp = __is.readByte();
        force = __is.readByte();
        fightMode = __is.readByte();
        combat = __is.readInt();
        life = __is.readInt();
        mana = __is.readInt();
        stamina = __is.readInt();
        globalCooldown = __is.readInt();
        avatar = __is.readInt();
        model = __is.readInt();
        talent = __is.readInt();
        growth = __is.readInt();
        code = __is.readInt();
        mountCode = __is.readInt();
        guildName = __is.readString();
        guildPosition = __is.readInt();
        baseFight = new SFightAttribute();
        baseFight.__read(__is);
        extraFight = new SFightAttribute();
        extraFight.__read(__is);
        addPercent = new SFightAttributeAddPercent();
        addPercent.__read(__is);
        skills = SeqSkillHelper.read(__is);
        buffs = SeqBuffHelper.read(__is);
        runes = SeqIntHelper.read(__is);
        entityShows = DictIntIntHelper.read(__is);
    }
}
}

