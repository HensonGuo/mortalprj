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


public class SBusinessInfo
{
    public var entityId : SEntityId;

    public var status : EBusinessStatus;

    public var name : String;

    public var level : int;

    public var camp : int;

    public var coin : int;

    public var gold : int;

    public var items : Dictionary;

    public function SBusinessInfo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        status.__write(__os);
        __os.writeString(name);
        __os.writeByte(level);
        __os.writeByte(camp);
        __os.writeInt(coin);
        __os.writeInt(gold);
        DictBusinessItemUpdateHelper.write(__os, items);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        status = EBusinessStatus.__read(__is);
        name = __is.readString();
        level = __is.readByte();
        camp = __is.readByte();
        coin = __is.readInt();
        gold = __is.readInt();
        items = DictBusinessItemUpdateHelper.read(__is);
    }
}
}
