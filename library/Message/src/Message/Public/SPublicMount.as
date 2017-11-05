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


public class SPublicMount extends IMessageBase 
{
    public var uid : String;

    public var code : int;

    public var level : int;

    public var experience : Number;

    public var expNum : int;

    public var tool : String;

    public var jsStr : String;

    public function SPublicMount(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicMount = new SPublicMount( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 84;

    override public function clone() : IMessageBase
    {
        return new SPublicMount;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(uid);
        __os.writeInt(code);
        __os.writeByte(level);
        __os.writeLong(experience);
        __os.writeInt(expNum);
        __os.writeString(tool);
        __os.writeString(jsStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        uid = __is.readString();
        code = __is.readInt();
        level = __is.readByte();
        experience = __is.readLong();
        expNum = __is.readInt();
        tool = __is.readString();
        jsStr = __is.readString();
    }
}
}
