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


public class TGuildLevelTarget
{
    public var guildLevel : int;

    public var guildLeaderAmount : int;

    public var deputyLeaderAmount : int;

    public var presbyterAmount : int;

    public var lawAmount : int;

    public var eliteAmount : int;

    public var maxMembers : int;

    public var maxMoney : int;

    public var maxResource : int;

    public var upgradeResource : int;

    public function TGuildLevelTarget()
    {
    }
}
}
