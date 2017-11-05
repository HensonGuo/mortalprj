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


public class TBossRefreshDefense
{
    public var id : int;

    public var mapId : int;

    public var plan : int;

    public var bossCode : int;

    public var refreshNum : int;

    public var refreshDistance : int;

    public var deadRefreshTime : int;

    public var startRefreshTime : int;

    public var fixedPoint : int;

    public var directionType : int;

    public var direction : int;

    public var moveRange : int;

    public var round : int;

    public var roundTimeInterval : int;

    public var loopCount : int;

    public var loopRoundInterval : int;

    public var deadRefreshId : int;

    public var wave : int;

    public var path : String;

    public var minRate : int;

    public var maxRate : int;

    public var rateRandomGroup : int;

    public var broadcastContext : String;

    public var dailyRefreshTime : String;

    public var openDate : int;

    public var minWorldLevel : int;

    public var maxWorldLevel : int;

    public function TBossRefreshDefense()
    {
    }
}
}
