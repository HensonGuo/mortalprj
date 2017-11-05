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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SBranchGuildInfo
{
    public var guildId : int;

    public var playerNum : int;

    public var maxPlayerNum : int;

    public var level : int;

    public function SBranchGuildInfo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(guildId);
        __os.writeInt(playerNum);
        __os.writeInt(maxPlayerNum);
        __os.writeInt(level);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        guildId = __is.readInt();
        playerNum = __is.readInt();
        maxPlayerNum = __is.readInt();
        level = __is.readInt();
    }
}
}
