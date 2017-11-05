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


public class SJoinGuildInfo extends IMessageBase 
{
    public var name : String;

    public var tpye : EJoinGuildType;

    public var miniGuild : SMiniGuildInfo;

    public var dealResult : int;

    public function SJoinGuildInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SJoinGuildInfo = new SJoinGuildInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16106;

    override public function clone() : IMessageBase
    {
        return new SJoinGuildInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(name);
        tpye.__write(__os);
        miniGuild.__write(__os);
        __os.writeInt(dealResult);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        name = __is.readString();
        tpye = EJoinGuildType.__read(__is);
        miniGuild = new SMiniGuildInfo();
        miniGuild.__read(__is);
        dealResult = __is.readInt();
    }
}
}
