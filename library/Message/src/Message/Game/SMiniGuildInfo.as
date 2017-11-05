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

import Message.Game.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMiniGuildInfo extends IMessageBase 
{
    public var guildId : int;

    public var guildName : String;

    public var purpose : String;

    public var camp : int;

    public var leaderName : String;

    public var level : int;

    public var playerNum : int;

    public var maxPlayerNum : int;

    public var rank : int;

    public var leaderVIP : int;

    [ArrayElementType("SBranchGuildInfo")]
    public var branch : Array;

    public function SMiniGuildInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SMiniGuildInfo = new SMiniGuildInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16102;

    override public function clone() : IMessageBase
    {
        return new SMiniGuildInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(guildId);
        __os.writeString(guildName);
        __os.writeString(purpose);
        __os.writeInt(camp);
        __os.writeString(leaderName);
        __os.writeInt(level);
        __os.writeInt(playerNum);
        __os.writeInt(maxPlayerNum);
        __os.writeInt(rank);
        __os.writeInt(leaderVIP);
        SeqBranchGuildInfoHelper.write(__os, branch);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        guildId = __is.readInt();
        guildName = __is.readString();
        purpose = __is.readString();
        camp = __is.readInt();
        leaderName = __is.readString();
        level = __is.readInt();
        playerNum = __is.readInt();
        maxPlayerNum = __is.readInt();
        rank = __is.readInt();
        leaderVIP = __is.readInt();
        branch = SeqBranchGuildInfoHelper.read(__is);
    }
}
}

