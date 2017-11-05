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


public class SDoFight extends IMessageBase 
{
    public var attackId : int;

    public var skillId : int;

    public var fromEntity : SEntityId;

    public var entity : SEntityId;

    [ArrayElementType("SAttributeUpdate")]
    public var propertyUpdates : Array;

    public function SDoFight(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDoFight = new SDoFight( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15953;

    override public function clone() : IMessageBase
    {
        return new SDoFight;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeShort(attackId);
        __os.writeInt(skillId);
        fromEntity.__write(__os);
        entity.__write(__os);
        SeqAttributeUpdateHelper.write(__os, propertyUpdates);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        attackId = __is.readShort();
        skillId = __is.readInt();
        fromEntity = new SEntityId();
        fromEntity.__read(__is);
        entity = new SEntityId();
        entity.__read(__is);
        propertyUpdates = SeqAttributeUpdateHelper.read(__is);
    }
}
}

