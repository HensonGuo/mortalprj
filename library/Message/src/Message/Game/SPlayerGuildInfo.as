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


public class SPlayerGuildInfo extends IMessageBase 
{
    public var playerId : int;

    public var guildId : int;

    public var branchLevel : int;

    public var guildName : String;

    public var level : int;

    public var position : int;

    public var playerNum : int;

    public var contributionDay : int;

    public var contributionWeek : int;

    public var totalContribution : int;

    public var activity : int;

    public var resource : int;

    public var lastEnterDt : Date;

    public function SPlayerGuildInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPlayerGuildInfo = new SPlayerGuildInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16100;

    override public function clone() : IMessageBase
    {
        return new SPlayerGuildInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeInt(guildId);
        __os.writeInt(branchLevel);
        __os.writeString(guildName);
        __os.writeInt(level);
        __os.writeInt(position);
        __os.writeInt(playerNum);
        __os.writeInt(contributionDay);
        __os.writeInt(contributionWeek);
        __os.writeInt(totalContribution);
        __os.writeInt(activity);
        __os.writeInt(resource);
        __os.writeDate(lastEnterDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        guildId = __is.readInt();
        branchLevel = __is.readInt();
        guildName = __is.readString();
        level = __is.readInt();
        position = __is.readInt();
        playerNum = __is.readInt();
        contributionDay = __is.readInt();
        contributionWeek = __is.readInt();
        totalContribution = __is.readInt();
        activity = __is.readInt();
        resource = __is.readInt();
        lastEnterDt = __is.readDate();
    }
}
}
