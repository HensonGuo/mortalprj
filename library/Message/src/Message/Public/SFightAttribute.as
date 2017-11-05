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


public class SFightAttribute extends IMessageBase 
{
    public var speed : int;

    public var attack : int;

    public var maxLife : int;

    public var maxMana : int;

    public var physDefense : int;

    public var magicDefense : int;

    public var penetration : int;

    public var jouk : int;

    public var hit : int;

    public var crit : int;

    public var toughness : int;

    public var block : int;

    public var expertise : int;

    public var damageReduce : int;

    public var crush : int;

    public var attackSpeed : int;

    public var attackDistance : int;

    public var attackType : int;

    public function SFightAttribute(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFightAttribute = new SFightAttribute( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 3021;

    override public function clone() : IMessageBase
    {
        return new SFightAttribute;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(speed);
        __os.writeInt(attack);
        __os.writeInt(maxLife);
        __os.writeInt(maxMana);
        __os.writeInt(physDefense);
        __os.writeInt(magicDefense);
        __os.writeInt(penetration);
        __os.writeInt(jouk);
        __os.writeInt(hit);
        __os.writeInt(crit);
        __os.writeInt(toughness);
        __os.writeInt(block);
        __os.writeInt(expertise);
        __os.writeInt(damageReduce);
        __os.writeInt(crush);
        __os.writeInt(attackSpeed);
        __os.writeInt(attackDistance);
        __os.writeInt(attackType);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        speed = __is.readInt();
        attack = __is.readInt();
        maxLife = __is.readInt();
        maxMana = __is.readInt();
        physDefense = __is.readInt();
        magicDefense = __is.readInt();
        penetration = __is.readInt();
        jouk = __is.readInt();
        hit = __is.readInt();
        crit = __is.readInt();
        toughness = __is.readInt();
        block = __is.readInt();
        expertise = __is.readInt();
        damageReduce = __is.readInt();
        crush = __is.readInt();
        attackSpeed = __is.readInt();
        attackDistance = __is.readInt();
        attackType = __is.readInt();
    }
}
}
