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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class STaskShowMsg extends IMessageBase 
{
    [ArrayElementType("int")]
    public var addIds : Array;

    [ArrayElementType("int")]
    public var delIds : Array;

    public function STaskShowMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:STaskShowMsg = new STaskShowMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16006;

    override public function clone() : IMessageBase
    {
        return new STaskShowMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqIntHelper.write(__os, addIds);
        SeqIntHelper.write(__os, delIds);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        addIds = SeqIntHelper.read(__is);
        delIds = SeqIntHelper.read(__is);
    }
}
}

