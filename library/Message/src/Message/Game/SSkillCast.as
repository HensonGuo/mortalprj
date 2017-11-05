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


public class SSkillCast extends IMessageBase 
{
    public var entityId : SEntityId;

    [ArrayElementType("SEntityId")]
    public var toEntityIds : Array;

    public var skillId : int;

    public var count : int;

    public var point : SPoint;

    public function SSkillCast(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSkillCast = new SSkillCast( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15955;

    override public function clone() : IMessageBase
    {
        return new SSkillCast;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        SeqEntityIdHelper.write(__os, toEntityIds);
        __os.writeInt(skillId);
        __os.writeInt(count);
        point.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        toEntityIds = SeqEntityIdHelper.read(__is);
        skillId = __is.readInt();
        count = __is.readInt();
        point = new SPoint();
        point.__read(__is);
    }
}
}

