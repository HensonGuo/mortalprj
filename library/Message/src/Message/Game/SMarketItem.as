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


public class SMarketItem
{
    public var recordId : Number;

    public var recordType : int;

    public var code : int;

    public var itemExtend : String;

    public var amount : int;

    public var ownerPlayerId : int;

    public var ownerName : String;

    public var serverId : int;

    public var sellPrice : int;

    public var sellUnit : int;

    public var createDt : Date;

    public var timeoutDt : Date;

    public function SMarketItem()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeLong(recordId);
        __os.writeInt(recordType);
        __os.writeInt(code);
        __os.writeString(itemExtend);
        __os.writeInt(amount);
        __os.writeInt(ownerPlayerId);
        __os.writeString(ownerName);
        __os.writeInt(serverId);
        __os.writeInt(sellPrice);
        __os.writeInt(sellUnit);
        __os.writeDate(createDt);
        __os.writeDate(timeoutDt);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        recordId = __is.readLong();
        recordType = __is.readInt();
        code = __is.readInt();
        itemExtend = __is.readString();
        amount = __is.readInt();
        ownerPlayerId = __is.readInt();
        ownerName = __is.readString();
        serverId = __is.readInt();
        sellPrice = __is.readInt();
        sellUnit = __is.readInt();
        createDt = __is.readDate();
        timeoutDt = __is.readDate();
    }
}
}
