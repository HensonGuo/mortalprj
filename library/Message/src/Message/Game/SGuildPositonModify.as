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


public class SGuildPositonModify extends IMessageBase 
{
    public var operName : String;

    public var guildName : String;

    public var positon : EGuildPosition;

    public function SGuildPositonModify(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildPositonModify = new SGuildPositonModify( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16113;

    override public function clone() : IMessageBase
    {
        return new SGuildPositonModify;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(operName);
        __os.writeString(guildName);
        positon.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        operName = __is.readString();
        guildName = __is.readString();
        positon = EGuildPosition.__read(__is);
    }
}
}
