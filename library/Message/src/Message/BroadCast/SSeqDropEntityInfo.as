// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.BroadCast{

import Message.BroadCast.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqDropEntityInfo extends IMessageBase 
{
    [ArrayElementType("SDropEntityInfo")]
    public var entityInfos : Array;

    public function SSeqDropEntityInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqDropEntityInfo = new SSeqDropEntityInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 11010;

    override public function clone() : IMessageBase
    {
        return new SSeqDropEntityInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqDropEntityInfoHelper.write(__os, entityInfos);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityInfos = SeqDropEntityInfoHelper.read(__is);
    }
}
}

