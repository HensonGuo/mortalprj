// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPlayerItem
{
    public var playerId : int;

    public var uid : String;

    public var itemCode : int;

    public var itemAmount : int;

    public var posType : int;

    public var createDt : Date;

    public var jsStr : String;

    public function SPlayerItem()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(uid);
        __os.writeInt(itemCode);
        __os.writeShort(itemAmount);
        __os.writeShort(posType);
        __os.writeDate(createDt);
        __os.writeString(jsStr);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        uid = __is.readString();
        itemCode = __is.readInt();
        itemAmount = __is.readShort();
        posType = __is.readShort();
        createDt = __is.readDate();
        jsStr = __is.readString();
    }
}
}
