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


public class SMyRole
{
    public var playerId : int;

    public var name : String;

    public var sex : int;

    public var camp : int;

    public var career : int;

    public var level : int;

    public var oldServerId : int;

    public var isMain : int;

    public function SMyRole()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(name);
        __os.writeInt(sex);
        __os.writeInt(camp);
        __os.writeInt(career);
        __os.writeInt(level);
        __os.writeInt(oldServerId);
        __os.writeInt(isMain);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        name = __is.readString();
        sex = __is.readInt();
        camp = __is.readInt();
        career = __is.readInt();
        level = __is.readInt();
        oldServerId = __is.readInt();
        isMain = __is.readInt();
    }
}
}
