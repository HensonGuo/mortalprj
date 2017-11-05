// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.DB.Tables{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class TPlayerFriend
{
    public var recordId : Number;

    public var player1Id : int;

    public var player1Name : String;

    public var player2Id : int;

    public var remark : String;

    public var flag : int;

    public var intimate : int;

    public var dailyFlower : int;

    public var lastTalkDt : Date;

    public var killedTimes : int;

    public var lastKilledDt : Date;

    public var cornucopiaBlessDt : Date;

    public var friendType : int;

    public function TPlayerFriend()
    {
    }
}
}
