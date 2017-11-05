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


public class SBuyBackItem
{
    public var uid : String;

    public var itemCode : int;

    public var amount : int;

    public var bind : int;

    public var sellTime : Date;

    public function SBuyBackItem()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(uid);
        __os.writeInt(itemCode);
        __os.writeInt(amount);
        __os.writeByte(bind);
        __os.writeDate(sellTime);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        uid = __is.readString();
        itemCode = __is.readInt();
        amount = __is.readInt();
        bind = __is.readByte();
        sellTime = __is.readDate();
    }
}
}
