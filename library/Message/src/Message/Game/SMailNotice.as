// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMailNotice extends IMessageBase 
{
    public var toPlayerId : int;

    public var type : int;

    public function SMailNotice(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SMailNotice = new SMailNotice( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15053;

    override public function clone() : IMessageBase
    {
        return new SMailNotice;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(toPlayerId);
        __os.writeInt(type);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        toPlayerId = __is.readInt();
        type = __is.readInt();
    }
}
}
