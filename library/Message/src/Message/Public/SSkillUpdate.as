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


public class SSkillUpdate extends IMessageBase 
{
    public var op : int;

    public var skill : SSkill;

    public function SSkillUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSkillUpdate = new SSkillUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2005;

    override public function clone() : IMessageBase
    {
        return new SSkillUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(op);
        skill.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        op = __is.readInt();
        skill = new SSkill();
        skill.__read(__is);
    }
}
}
