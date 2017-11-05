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


public class SFirstRole
{
    public var name : String;

    public var camp : int;

    public var sex : int;

    public var career : int;

    public var gateIp : String;

    public var server : String;

    public var platformCode : String;

    public function SFirstRole()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(name);
        __os.writeInt(camp);
        __os.writeInt(sex);
        __os.writeInt(career);
        __os.writeString(gateIp);
        __os.writeString(server);
        __os.writeString(platformCode);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        name = __is.readString();
        camp = __is.readInt();
        sex = __is.readInt();
        career = __is.readInt();
        gateIp = __is.readString();
        server = __is.readString();
        platformCode = __is.readString();
    }
}
}
