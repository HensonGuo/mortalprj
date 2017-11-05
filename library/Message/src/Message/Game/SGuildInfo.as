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
import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SGuildInfo extends IMessageBase 
{
    public var guildId : int;

    public var guildName : String;

    public var purpose : String;

    public var YY : String;

    public var QQ : String;

    public var playerNum : int;

    public var maxPlayerNum : int;

    public var level : int;

    public var leader : SMiniPlayer;

    public var resource : int;

    public var money : int;

    public var maxMoney : int;

    public var camp : int;

    public var rank : int;

    [ArrayElementType("String")]
    public var deputyLeaderNames : Array;

    [ArrayElementType("String")]
    public var PresbyterNames : Array;

    [ArrayElementType("SBranchGuildInfo")]
    public var branch : Array;

    public function SGuildInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildInfo = new SGuildInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16101;

    override public function clone() : IMessageBase
    {
        return new SGuildInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(guildId);
        __os.writeString(guildName);
        __os.writeString(purpose);
        __os.writeString(YY);
        __os.writeString(QQ);
        __os.writeInt(playerNum);
        __os.writeInt(maxPlayerNum);
        __os.writeInt(level);
        leader.__write(__os);
        __os.writeInt(resource);
        __os.writeInt(money);
        __os.writeInt(maxMoney);
        __os.writeInt(camp);
        __os.writeInt(rank);
        SeqStringHelper.write(__os, deputyLeaderNames);
        SeqStringHelper.write(__os, PresbyterNames);
        SeqBranchGuildInfoHelper.write(__os, branch);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        guildId = __is.readInt();
        guildName = __is.readString();
        purpose = __is.readString();
        YY = __is.readString();
        QQ = __is.readString();
        playerNum = __is.readInt();
        maxPlayerNum = __is.readInt();
        level = __is.readInt();
        leader = new SMiniPlayer();
        leader.__read(__is);
        resource = __is.readInt();
        money = __is.readInt();
        maxMoney = __is.readInt();
        camp = __is.readInt();
        rank = __is.readInt();
        deputyLeaderNames = SeqStringHelper.read(__is);
        PresbyterNames = SeqStringHelper.read(__is);
        branch = SeqBranchGuildInfoHelper.read(__is);
    }
}
}

