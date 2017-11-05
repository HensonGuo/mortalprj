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


public class SBag extends IMessageBase 
{
    public var posType : int;

    public var capacity : int;

    [ArrayElementType("SPlayerItem")]
    public var playerItems : Array;

    public function SBag(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBag = new SBag( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15072;

    override public function clone() : IMessageBase
    {
        return new SBag;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(posType);
        __os.writeInt(capacity);
        SeqPlayerItemHelper.write(__os, playerItems);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        posType = __is.readInt();
        capacity = __is.readInt();
        playerItems = SeqPlayerItemHelper.read(__is);
    }
}
}

