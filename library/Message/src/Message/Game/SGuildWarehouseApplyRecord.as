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


public class SGuildWarehouseApplyRecord extends IMessageBase 
{
    public var endDate : Date;

    public var oprName : String;

    public var dealName : String;

    public var uid : String;

    public var itemCode : int;

    public var amount : int;

    public var uint : int;

    public var reason : int;

    public function SGuildWarehouseApplyRecord(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildWarehouseApplyRecord = new SGuildWarehouseApplyRecord( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16111;

    override public function clone() : IMessageBase
    {
        return new SGuildWarehouseApplyRecord;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeDate(endDate);
        __os.writeString(oprName);
        __os.writeString(dealName);
        __os.writeString(uid);
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        __os.writeInt(uint);
        __os.writeInt(reason);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        endDate = __is.readDate();
        oprName = __is.readString();
        dealName = __is.readString();
        uid = __is.readString();
        itemCode = __is.readInt();
        amount = __is.readInt();
        uint = __is.readInt();
        reason = __is.readInt();
    }
}
}
