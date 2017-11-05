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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SGuildMember extends IMessageBase 
{
    public var miniPlayer : SMiniPlayer;

    public var branchGuildLevel : int;

    public var position : int;

    public var contributionDay : int;

    public var contributionWeek : int;

    public var totalContribution : int;

    public var activity : int;

    public var resource : int;

    public var lastLogoutDt : Date;

    public function SGuildMember(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildMember = new SGuildMember( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16103;

    override public function clone() : IMessageBase
    {
        return new SGuildMember;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        miniPlayer.__write(__os);
        __os.writeInt(branchGuildLevel);
        __os.writeInt(position);
        __os.writeInt(contributionDay);
        __os.writeInt(contributionWeek);
        __os.writeInt(totalContribution);
        __os.writeInt(activity);
        __os.writeInt(resource);
        __os.writeDate(lastLogoutDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        miniPlayer = new SMiniPlayer();
        miniPlayer.__read(__is);
        branchGuildLevel = __is.readInt();
        position = __is.readInt();
        contributionDay = __is.readInt();
        contributionWeek = __is.readInt();
        totalContribution = __is.readInt();
        activity = __is.readInt();
        resource = __is.readInt();
        lastLogoutDt = __is.readDate();
    }
}
}

