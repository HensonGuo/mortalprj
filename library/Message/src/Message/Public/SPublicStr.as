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


public class SPublicStr extends IMessageBase 
{
    public var publicStr : String;

    public function SPublicStr(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicStr = new SPublicStr( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 105;

    override public function clone() : IMessageBase
    {
        return new SPublicStr;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(publicStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        publicStr = __is.readString();
    }
}
}
