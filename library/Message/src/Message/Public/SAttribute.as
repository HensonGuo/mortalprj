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


public class SAttribute extends IMessageBase 
{
    public var value : int;

    public var valueStr : String;

    public function SAttribute(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SAttribute = new SAttribute( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2003;

    override public function clone() : IMessageBase
    {
        return new SAttribute;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(value);
        __os.writeString(valueStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        value = __is.readInt();
        valueStr = __is.readString();
    }
}
}
