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


public class SPanicBuyPlayerMsg extends IMessageBase 
{
    public var code : int;

    public var item1Index : int;

    public var item1BuyAmount : int;

    public var item2Index : int;

    public var item2BuyAmount : int;

    public var item3Index : int;

    public var item3BuyAmount : int;

    public var buyItemDt : Date;

    public function SPanicBuyPlayerMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPanicBuyPlayerMsg = new SPanicBuyPlayerMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15077;

    override public function clone() : IMessageBase
    {
        return new SPanicBuyPlayerMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(code);
        __os.writeInt(item1Index);
        __os.writeInt(item1BuyAmount);
        __os.writeInt(item2Index);
        __os.writeInt(item2BuyAmount);
        __os.writeInt(item3Index);
        __os.writeInt(item3BuyAmount);
        __os.writeDate(buyItemDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        code = __is.readInt();
        item1Index = __is.readInt();
        item1BuyAmount = __is.readInt();
        item2Index = __is.readInt();
        item2BuyAmount = __is.readInt();
        item3Index = __is.readInt();
        item3BuyAmount = __is.readInt();
        buyItemDt = __is.readDate();
    }
}
}
