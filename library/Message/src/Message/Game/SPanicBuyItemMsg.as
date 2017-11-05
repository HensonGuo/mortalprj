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


public class SPanicBuyItemMsg extends IMessageBase 
{
    public var type : int;

    public var itemCode : int;

    public var discount : int;

    public var leftAmount : int;

    public var index : int;

    public function SPanicBuyItemMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPanicBuyItemMsg = new SPanicBuyItemMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15075;

    override public function clone() : IMessageBase
    {
        return new SPanicBuyItemMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        __os.writeInt(itemCode);
        __os.writeInt(discount);
        __os.writeInt(leftAmount);
        __os.writeInt(index);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        itemCode = __is.readInt();
        discount = __is.readInt();
        leftAmount = __is.readInt();
        index = __is.readInt();
    }
}
}
