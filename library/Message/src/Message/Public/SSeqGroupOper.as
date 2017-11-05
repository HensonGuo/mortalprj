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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqGroupOper extends IMessageBase 
{
    [ArrayElementType("SGroupOper")]
    public var opers : Array;

    public function SSeqGroupOper(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqGroupOper = new SSeqGroupOper( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 4005;

    override public function clone() : IMessageBase
    {
        return new SSeqGroupOper;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqGroupOperHelper.write(__os, opers);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        opers = SeqGroupOperHelper.read(__is);
    }
}
}

