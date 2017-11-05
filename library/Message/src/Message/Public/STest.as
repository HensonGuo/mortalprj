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


public class STest extends IMessageBase 
{
    public var t1 : int;

    public var t2 : int;

    public var t3 : int;

    public var t4 : String;

    public function STest(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:STest = new STest( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 9900;

    override public function clone() : IMessageBase
    {
        return new STest;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte(t1);
        __os.writeShort(t2);
        __os.writeInt(t3);
        __os.writeString(t4);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        t1 = __is.readByte();
        t2 = __is.readShort();
        t3 = __is.readInt();
        t4 = __is.readString();
    }
}
}
