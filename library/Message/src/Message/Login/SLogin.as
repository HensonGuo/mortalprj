// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Login{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SLogin
{
    public var username : String;

    public var userId : int;

    public var server : String;

    public var time : Date;

    public var flag : String;

    public var country : int;

    public var isAdult : int;

    public var setIsMain : int;

    public var platformCode : String;

    public var password : String;

    public var loginIp : String;

    public var totalOnlineTime : int;

    public var platformUserName : String;

    public var issm : int;

    public var playerId : int;

    public var gateIp : String;

    public var codeVersion : String;

    public function SLogin()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(username);
        __os.writeInt(userId);
        __os.writeString(server);
        __os.writeDate(time);
        __os.writeString(flag);
        __os.writeInt(country);
        __os.writeInt(isAdult);
        __os.writeInt(setIsMain);
        __os.writeString(platformCode);
        __os.writeString(password);
        __os.writeString(loginIp);
        __os.writeInt(totalOnlineTime);
        __os.writeString(platformUserName);
        __os.writeInt(issm);
        __os.writeInt(playerId);
        __os.writeString(gateIp);
        __os.writeString(codeVersion);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        username = __is.readString();
        userId = __is.readInt();
        server = __is.readString();
        time = __is.readDate();
        flag = __is.readString();
        country = __is.readInt();
        isAdult = __is.readInt();
        setIsMain = __is.readInt();
        platformCode = __is.readString();
        password = __is.readString();
        loginIp = __is.readString();
        totalOnlineTime = __is.readInt();
        platformUserName = __is.readString();
        issm = __is.readInt();
        playerId = __is.readInt();
        gateIp = __is.readString();
        codeVersion = __is.readString();
    }
}
}
