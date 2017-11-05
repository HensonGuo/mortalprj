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


public class SLoginInfoShow extends IMessageBase 
{
    public var name : String;

    public var sex : int;

    public var camp : int;

    public function SLoginInfoShow(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SLoginInfoShow = new SLoginInfoShow( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 102;

    override public function clone() : IMessageBase
    {
        return new SLoginInfoShow;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(name);
        __os.writeByte(sex);
        __os.writeByte(camp);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        name = __is.readString();
        sex = __is.readByte();
        camp = __is.readByte();
    }
}
}
