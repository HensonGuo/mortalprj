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


public class SGuildWarehouseApply
{
    public var playerId : int;

    public var name : String;

    public var uid : String;

    public var itemCode : int;

    public var unit : int;

    public var amount : int;

    public var jsStr : String;

    public var state : EGuildWarehouseState;

    public function SGuildWarehouseApply()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(name);
        __os.writeString(uid);
        __os.writeInt(itemCode);
        __os.writeInt(unit);
        __os.writeInt(amount);
        __os.writeString(jsStr);
        state.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        name = __is.readString();
        uid = __is.readString();
        itemCode = __is.readInt();
        unit = __is.readInt();
        amount = __is.readInt();
        jsStr = __is.readString();
        state = EGuildWarehouseState.__read(__is);
    }
}
}
