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


public class SMapDefine
{
    public var mapId : int;

    public var groupId : int;

    public var name : String;

    public var instanceType : EMapInstanceType;

    public var realWidth : int;

    public var realHeight : int;

    public var clientFile : int;

    public var serverFile : String;

    public var ownerType : EMapOwnerType;

    public var belong : EMapBelong;

    public var fightMode : int;

    public var needLevel : int;

    public var enterMode : int;

    public var enterPoint : SPoint;

    public var subline : Boolean;

    public var cross : Boolean;

    public var restrictionType : int;

    public var revivalRestriction : Dictionary;

    public var revivalMaps : Dictionary;

    [ArrayElementType("SPassPoint")]
    public var passPoints : Array;

    [ArrayElementType("SNpc")]
    public var npcs : Array;

    [ArrayElementType("SMapSharp")]
    public var sharps : Array;

    public var weather : int;

    public var musicId : int;

    [ArrayElementType("SMapDeathEvent")]
    public var deathEvents : Array;

    public var taxRate : int;

    [ArrayElementType("Array")]
    public var jumpPointSeq : Array;

    [ArrayElementType("SMapArea")]
    public var areas : Array;

    public var defaultBossPoint : Boolean;

    public var bossPoint : SPoint;

    public var showLimit : int;

    public function SMapDefine()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(mapId);
        __os.writeInt(groupId);
        __os.writeString(name);
        instanceType.__write(__os);
        __os.writeInt(realWidth);
        __os.writeInt(realHeight);
        __os.writeInt(clientFile);
        __os.writeString(serverFile);
        ownerType.__write(__os);
        belong.__write(__os);
        __os.writeInt(fightMode);
        __os.writeInt(needLevel);
        __os.writeInt(enterMode);
        enterPoint.__write(__os);
        __os.writeBool(subline);
        __os.writeBool(cross);
        __os.writeInt(restrictionType);
        DictIntIntHelper.write(__os, revivalRestriction);
        DictIntIntHelper.write(__os, revivalMaps);
        SeqPassPointHelper.write(__os, passPoints);
        SeqNpcHelper.write(__os, npcs);
        SeqMapSharpHelper.write(__os, sharps);
        __os.writeInt(weather);
        __os.writeInt(musicId);
        SeqMapDeathEventHelper.write(__os, deathEvents);
        __os.writeInt(taxRate);
        SeqPointSeqHelper.write(__os, jumpPointSeq);
        SeqMapAreaHelper.write(__os, areas);
        __os.writeBool(defaultBossPoint);
        bossPoint.__write(__os);
        __os.writeInt(showLimit);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        mapId = __is.readInt();
        groupId = __is.readInt();
        name = __is.readString();
        instanceType = EMapInstanceType.__read(__is);
        realWidth = __is.readInt();
        realHeight = __is.readInt();
        clientFile = __is.readInt();
        serverFile = __is.readString();
        ownerType = EMapOwnerType.__read(__is);
        belong = EMapBelong.__read(__is);
        fightMode = __is.readInt();
        needLevel = __is.readInt();
        enterMode = __is.readInt();
        enterPoint = new SPoint();
        enterPoint.__read(__is);
        subline = __is.readBool();
        cross = __is.readBool();
        restrictionType = __is.readInt();
        revivalRestriction = DictIntIntHelper.read(__is);
        revivalMaps = DictIntIntHelper.read(__is);
        passPoints = SeqPassPointHelper.read(__is);
        npcs = SeqNpcHelper.read(__is);
        sharps = SeqMapSharpHelper.read(__is);
        weather = __is.readInt();
        musicId = __is.readInt();
        deathEvents = SeqMapDeathEventHelper.read(__is);
        taxRate = __is.readInt();
        jumpPointSeq = SeqPointSeqHelper.read(__is);
        areas = SeqMapAreaHelper.read(__is);
        defaultBossPoint = __is.readBool();
        bossPoint = new SPoint();
        bossPoint.__read(__is);
        showLimit = __is.readInt();
    }
}
}

