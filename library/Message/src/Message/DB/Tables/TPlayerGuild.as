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


public class TPlayerGuild
{
    public var id : int;

    public var playerId : int;

    public var guildId : int;

    public var branchGuildLevel : int;

    public var position : int;

    public var lastLeaveDt : Date;

    public var contribution : int;

    public var contributionDay : int;

    public var contributionWeek : int;

    public var totalContribution : int;

    public var activity : int;

    public var resource : int;

    public var lastAwardDt : Date;

    public var lastLogoutDt : Date;

    public var lastEnterDt : Date;

    public var jsStr : String;

    public function TPlayerGuild()
    {
    }
}
}
