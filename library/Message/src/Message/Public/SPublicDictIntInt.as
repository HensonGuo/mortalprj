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


public class SPublicDictIntInt extends IMessageBase 
{
    public var publicDictIntInt : Dictionary;

    public function SPublicDictIntInt(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicDictIntInt = new SPublicDictIntInt( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 108;

    override public function clone() : IMessageBase
    {
        return new SPublicDictIntInt;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        DictIntIntHelper.write(__os, publicDictIntInt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        publicDictIntInt = DictIntIntHelper.read(__is);
    }
}
}
