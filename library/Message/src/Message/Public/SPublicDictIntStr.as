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


public class SPublicDictIntStr extends IMessageBase 
{
    public var publicDictIntStr : Dictionary;

    public function SPublicDictIntStr(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicDictIntStr = new SPublicDictIntStr( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 107;

    override public function clone() : IMessageBase
    {
        return new SPublicDictIntStr;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        DictIntStrHelper.write(__os, publicDictIntStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        publicDictIntStr = DictIntStrHelper.read(__is);
    }
}
}
