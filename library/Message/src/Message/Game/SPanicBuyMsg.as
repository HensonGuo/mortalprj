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


public class SPanicBuyMsg extends IMessageBase 
{
    public var type : int;

    [ArrayElementType("SPanicBuyItemMsg")]
    public var panicBuyItems : Array;

    public var panicBuyShop : SPanicBuyShopMsg;

    public function SPanicBuyMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPanicBuyMsg = new SPanicBuyMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15076;

    override public function clone() : IMessageBase
    {
        return new SPanicBuyMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        SeqPanicBuyItemMsgHelper.write(__os, panicBuyItems);
        panicBuyShop.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        panicBuyItems = SeqPanicBuyItemMsgHelper.read(__is);
        panicBuyShop = new SPanicBuyShopMsg();
        panicBuyShop.__read(__is);
    }
}
}

