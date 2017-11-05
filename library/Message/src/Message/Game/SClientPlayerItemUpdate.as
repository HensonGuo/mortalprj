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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SClientPlayerItemUpdate
{
    public var updateType : int;

    public var fromPosType : int;

    public var updateAmount : int;

    public var playerItem : SPlayerItem;

    public function SClientPlayerItemUpdate()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte(updateType);
        __os.writeShort(fromPosType);
        __os.writeShort(updateAmount);
        playerItem.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        updateType = __is.readByte();
        fromPosType = __is.readShort();
        updateAmount = __is.readShort();
        playerItem = new SPlayerItem();
        playerItem.__read(__is);
    }
}
}

