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


public class SGuildWarehouseMyApply extends IMessageBase 
{
    public var endDate : Date;

    public var position : int;

    public var name : String;

    public var itemCode : int;

    public var amount : int;

    public function SGuildWarehouseMyApply(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildWarehouseMyApply = new SGuildWarehouseMyApply( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16110;

    override public function clone() : IMessageBase
    {
        return new SGuildWarehouseMyApply;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeDate(endDate);
        __os.writeInt(position);
        __os.writeString(name);
        __os.writeInt(itemCode);
        __os.writeInt(amount);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        endDate = __is.readDate();
        position = __is.readInt();
        name = __is.readString();
        itemCode = __is.readInt();
        amount = __is.readInt();
    }
}
}
