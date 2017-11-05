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


public class TMarketRecord
{
    public var recordId : int;

    public var recordType : int;

    public var code : int;

    public var ownerPlayerId : int;

    public var ownerName : String;

    public var serverId : int;

    public var amount : int;

    public var itemExtend : String;

    public var marketId : int;

    public var level : int;

    public var career : int;

    public var color : int;

    public var sellUnit : int;

    public var sellPrice : int;

    public var sellUnitPrice : int;

    public var sellDt : Date;

    public var timeoutDt : Date;

    public function TMarketRecord()
    {
    }
}
}
