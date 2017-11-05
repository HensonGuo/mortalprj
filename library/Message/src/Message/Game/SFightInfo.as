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


public class SFightInfo extends IMessageBase 
{
    public var fromEntity : SEntityId;

    public var toEntity : SEntityId;

    public var attackType : EAttackType;

    public var fromEntityLevel : int;

    public var skillId : int;

    public var minAttack : int;

    public var maxAttack : int;

    public var crit : int;

    public var hit : int;

    public var penetration : int;

    public var expertise : int;

    public var crush : int;

    public var hitRate : int;

    public var attackId : int;

    public var mousePoint : SPoint;

    public var skillFightType : int;

    public function SFightInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFightInfo = new SFightInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15951;

    override public function clone() : IMessageBase
    {
        return new SFightInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        fromEntity.__write(__os);
        toEntity.__write(__os);
        attackType.__write(__os);
        __os.writeInt(fromEntityLevel);
        __os.writeInt(skillId);
        __os.writeInt(minAttack);
        __os.writeInt(maxAttack);
        __os.writeInt(crit);
        __os.writeInt(hit);
        __os.writeInt(penetration);
        __os.writeInt(expertise);
        __os.writeInt(crush);
        __os.writeInt(hitRate);
        __os.writeShort(attackId);
        mousePoint.__write(__os);
        __os.writeInt(skillFightType);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        fromEntity = new SEntityId();
        fromEntity.__read(__is);
        toEntity = new SEntityId();
        toEntity.__read(__is);
        attackType = EAttackType.__read(__is);
        fromEntityLevel = __is.readInt();
        skillId = __is.readInt();
        minAttack = __is.readInt();
        maxAttack = __is.readInt();
        crit = __is.readInt();
        hit = __is.readInt();
        penetration = __is.readInt();
        expertise = __is.readInt();
        crush = __is.readInt();
        hitRate = __is.readInt();
        attackId = __is.readShort();
        mousePoint = new SPoint();
        mousePoint.__read(__is);
        skillFightType = __is.readInt();
    }
}
}

