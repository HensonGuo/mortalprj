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

import Message.Game.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqMarketItem extends IMessageBase 
{
    public var recordType : int;

    public var amount : int;

    public var targetPage : int;

    public var totalPage : int;

    [ArrayElementType("SMarketItem")]
    public var marketItems : Array;

    public function SSeqMarketItem(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqMarketItem = new SSeqMarketItem( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16201;

    override public function clone() : IMessageBase
    {
        return new SSeqMarketItem;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(recordType);
        __os.writeInt(amount);
        __os.writeInt(targetPage);
        __os.writeInt(totalPage);
        SeqMarketItemHelper.write(__os, marketItems);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        recordType = __is.readInt();
        amount = __is.readInt();
        targetPage = __is.readInt();
        totalPage = __is.readInt();
        marketItems = SeqMarketItemHelper.read(__is);
    }
}
}

