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


public class SSeqPlayerItem extends IMessageBase 
{
    [ArrayElementType("SPlayerItem")]
    public var playerItem : Array;

    public function SSeqPlayerItem(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqPlayerItem = new SSeqPlayerItem( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 61;

    override public function clone() : IMessageBase
    {
        return new SSeqPlayerItem;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqPlayerItemHelper.write(__os, playerItem);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        playerItem = SeqPlayerItemHelper.read(__is);
    }
}
}

