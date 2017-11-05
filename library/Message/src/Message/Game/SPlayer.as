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


public class SPlayer extends IMessageBase 
{
    public var playerId : int;

    public var username : String;

    public var name : String;

    public var sex : int;

    public var camp : int;

    public var createDt : Date;

    public var flag : int;

    public var mode : int;

    public var status : int;

    public var issm : int;

    public var VIP : int;

    public var headCode : int;

    public var signature : String;

    public var lastLoginDt : Date;

    public var onlineDays : int;

    public var onlineTime : int;

    public var offlineTime : int;

    public var guildId : int;

    public function SPlayer(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPlayer = new SPlayer( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15001;

    override public function clone() : IMessageBase
    {
        return new SPlayer;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(username);
        __os.writeString(name);
        __os.writeByte(sex);
        __os.writeInt(camp);
        __os.writeDate(createDt);
        __os.writeInt(flag);
        __os.writeInt(mode);
        __os.writeInt(status);
        __os.writeInt(issm);
        __os.writeByte(VIP);
        __os.writeInt(headCode);
        __os.writeString(signature);
        __os.writeDate(lastLoginDt);
        __os.writeInt(onlineDays);
        __os.writeInt(onlineTime);
        __os.writeInt(offlineTime);
        __os.writeInt(guildId);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        username = __is.readString();
        name = __is.readString();
        sex = __is.readByte();
        camp = __is.readInt();
        createDt = __is.readDate();
        flag = __is.readInt();
        mode = __is.readInt();
        status = __is.readInt();
        issm = __is.readInt();
        VIP = __is.readByte();
        headCode = __is.readInt();
        signature = __is.readString();
        lastLoginDt = __is.readDate();
        onlineDays = __is.readInt();
        onlineTime = __is.readInt();
        offlineTime = __is.readInt();
        guildId = __is.readInt();
    }
}
}
