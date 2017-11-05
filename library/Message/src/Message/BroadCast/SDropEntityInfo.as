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


public class SDropEntityInfo extends IMessageBase 
{
    public var entityId : SEntityId;

    public var ownerEntityId : SEntityId;

    [ArrayElementType("SPlayerItem")]
    public var playerItems : Array;

    public var point : SPoint;

    public var unit : int;

    public var cost : int;

    public var bossCode : int;

    public var mapId : int;

    public var dropDt : Date;

    public function SDropEntityInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDropEntityInfo = new SDropEntityInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 11009;

    override public function clone() : IMessageBase
    {
        return new SDropEntityInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        ownerEntityId.__write(__os);
        SeqPlayerItemHelper.write(__os, playerItems);
        point.__write(__os);
        __os.writeInt(unit);
        __os.writeInt(cost);
        __os.writeInt(bossCode);
        __os.writeInt(mapId);
        __os.writeDate(dropDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        ownerEntityId = new SEntityId();
        ownerEntityId.__read(__is);
        playerItems = SeqPlayerItemHelper.read(__is);
        point = new SPoint();
        point.__read(__is);
        unit = __is.readInt();
        cost = __is.readInt();
        bossCode = __is.readInt();
        mapId = __is.readInt();
        dropDt = __is.readDate();
    }
}
}

