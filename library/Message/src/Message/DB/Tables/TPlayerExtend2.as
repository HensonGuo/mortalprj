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


public class TPlayerExtend2
{
    public var id : int;

    public var playerId : int;

    public var issm : int;

    public var online : int;

    public var loginIp : String;

    public var platformOnlineTime : int;

    public var lastLoginDt : Date;

    public var todayOnlineTime : int;

    public var onlineTime : int;

    public var lastOfflineDt : Date;

    public var offlineTime : int;

    public var onlineDays : int;

    public var offlineExpTime : int;

    public var totalOfflineExp : Number;

    public var platform : int;

    public var gateChannelId : int;

    public function TPlayerExtend2()
    {
    }
}
}
