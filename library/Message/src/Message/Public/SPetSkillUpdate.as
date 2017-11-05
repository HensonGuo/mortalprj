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


public class SPetSkillUpdate extends IMessageBase 
{
    public var op : int;

    public var skill : SSkill;

    public var petUid : String;

    public function SPetSkillUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPetSkillUpdate = new SPetSkillUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2008;

    override public function clone() : IMessageBase
    {
        return new SPetSkillUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(op);
        skill.__write(__os);
        __os.writeString(petUid);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        op = __is.readInt();
        skill = new SSkill();
        skill.__read(__is);
        petUid = __is.readString();
    }
}
}
