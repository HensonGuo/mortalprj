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


public class SFightAttributeAddPercent extends IMessageBase 
{
    public var attackAdd : int;

    public var maxLifeAdd : int;

    public var maxManaAdd : int;

    public var physDefenseAdd : int;

    public var magicDefenseAdd : int;

    public var penetrationAdd : int;

    public var joukAdd : int;

    public var hitAdd : int;

    public var critAdd : int;

    public var toughnessAdd : int;

    public var blockAdd : int;

    public var expertiseAdd : int;

    public var damageReduceAdd : int;

    public var damageDeeperAdd : int;

    public var speedAdd : int;

    public function SFightAttributeAddPercent(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SFightAttributeAddPercent = new SFightAttributeAddPercent( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 3023;

    override public function clone() : IMessageBase
    {
        return new SFightAttributeAddPercent;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(attackAdd);
        __os.writeInt(maxLifeAdd);
        __os.writeInt(maxManaAdd);
        __os.writeInt(physDefenseAdd);
        __os.writeInt(magicDefenseAdd);
        __os.writeInt(penetrationAdd);
        __os.writeInt(joukAdd);
        __os.writeInt(hitAdd);
        __os.writeInt(critAdd);
        __os.writeInt(toughnessAdd);
        __os.writeInt(blockAdd);
        __os.writeInt(expertiseAdd);
        __os.writeInt(damageReduceAdd);
        __os.writeInt(damageDeeperAdd);
        __os.writeInt(speedAdd);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        attackAdd = __is.readInt();
        maxLifeAdd = __is.readInt();
        maxManaAdd = __is.readInt();
        physDefenseAdd = __is.readInt();
        magicDefenseAdd = __is.readInt();
        penetrationAdd = __is.readInt();
        joukAdd = __is.readInt();
        hitAdd = __is.readInt();
        critAdd = __is.readInt();
        toughnessAdd = __is.readInt();
        blockAdd = __is.readInt();
        expertiseAdd = __is.readInt();
        damageReduceAdd = __is.readInt();
        damageDeeperAdd = __is.readInt();
        speedAdd = __is.readInt();
    }
}
}
