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


public class SFriendRecord
{
    public var recordId : Number;

    public var friendPlayer : SMiniPlayer;

    public var remark : String;

    public var flag : int;

    public var intimate : int;

    public var killedTimes : int;

    public var lastTalkDt : Date;

    public var lastKilledDt : Date;

    public var friendType : int;

    public function SFriendRecord()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeLong(recordId);
        friendPlayer.__write(__os);
        __os.writeString(remark);
        __os.writeInt(flag);
        __os.writeInt(intimate);
        __os.writeInt(killedTimes);
        __os.writeDate(lastTalkDt);
        __os.writeDate(lastKilledDt);
        __os.writeInt(friendType);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        recordId = __is.readLong();
        friendPlayer = new SMiniPlayer();
        friendPlayer.__read(__is);
        remark = __is.readString();
        flag = __is.readInt();
        intimate = __is.readInt();
        killedTimes = __is.readInt();
        lastTalkDt = __is.readDate();
        lastKilledDt = __is.readDate();
        friendType = __is.readInt();
    }
}
}

