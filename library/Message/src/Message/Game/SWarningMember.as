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


public class SWarningMember extends IMessageBase 
{
    public var miniPlayer : SMiniPlayer;

    public var position : int;

    public var loginOutDays : int;

    public var activity : int;

    public var chatTimes : int;

    public var contributionWeek : int;

    public var reason : int;

    public function SWarningMember(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SWarningMember = new SWarningMember( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16107;

    override public function clone() : IMessageBase
    {
        return new SWarningMember;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        miniPlayer.__write(__os);
        __os.writeInt(position);
        __os.writeInt(loginOutDays);
        __os.writeInt(activity);
        __os.writeInt(chatTimes);
        __os.writeInt(contributionWeek);
        __os.writeInt(reason);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        miniPlayer = new SMiniPlayer();
        miniPlayer.__read(__is);
        position = __is.readInt();
        loginOutDays = __is.readInt();
        activity = __is.readInt();
        chatTimes = __is.readInt();
        contributionWeek = __is.readInt();
        reason = __is.readInt();
    }
}
}

