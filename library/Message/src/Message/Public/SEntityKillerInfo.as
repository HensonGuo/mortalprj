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


public class SEntityKillerInfo extends IMessageBase 
{
    public var entityId : SEntityId;

    public var camp : int;

    public var force : int;

    public var level : int;

    public var name : String;

    public function SEntityKillerInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SEntityKillerInfo = new SEntityKillerInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 52;

    override public function clone() : IMessageBase
    {
        return new SEntityKillerInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        __os.writeInt(camp);
        __os.writeInt(force);
        __os.writeInt(level);
        __os.writeString(name);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        camp = __is.readInt();
        force = __is.readInt();
        level = __is.readInt();
        name = __is.readString();
    }
}
}
