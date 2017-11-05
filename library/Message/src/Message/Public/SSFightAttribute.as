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


public class SSFightAttribute extends IMessageBase 
{
    public var uid : String;

    public var baseFight : SFightAttribute;

    public function SSFightAttribute(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSFightAttribute = new SSFightAttribute( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 3022;

    override public function clone() : IMessageBase
    {
        return new SSFightAttribute;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(uid);
        baseFight.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        uid = __is.readString();
        baseFight = new SFightAttribute();
        baseFight.__read(__is);
    }
}
}
