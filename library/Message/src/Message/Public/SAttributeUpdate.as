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


public class SAttributeUpdate extends IMessageBase 
{
    public var attribute : EEntityAttribute;

    public var value : int;

    public var valueStr : String;

    public function SAttributeUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SAttributeUpdate = new SAttributeUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2001;

    override public function clone() : IMessageBase
    {
        return new SAttributeUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        attribute.__write(__os);
        __os.writeInt(value);
        __os.writeString(valueStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        attribute = EEntityAttribute.__read(__is);
        value = __is.readInt();
        valueStr = __is.readString();
    }
}
}
