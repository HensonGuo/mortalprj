// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SCopyGroupInfo
{
    public var groupId : SEntityId;

    public var captainId : SEntityId;

    public var captainName : String;

    public var captainLevel : int;

    public var captainSex : int;

    public var captainCamp : int;

    public var playerNum : int;

    public var progress : int;

    [ArrayElementType("SPublicPlayer")]
    public var members : Array;

    public function SCopyGroupInfo()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        groupId.__write(__os);
        captainId.__write(__os);
        __os.writeString(captainName);
        __os.writeInt(captainLevel);
        __os.writeInt(captainSex);
        __os.writeInt(captainCamp);
        __os.writeInt(playerNum);
        __os.writeInt(progress);
        SeqPublicPlayerHelper.write(__os, members);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        groupId = new SEntityId();
        groupId.__read(__is);
        captainId = new SEntityId();
        captainId.__read(__is);
        captainName = __is.readString();
        captainLevel = __is.readInt();
        captainSex = __is.readInt();
        captainCamp = __is.readInt();
        playerNum = __is.readInt();
        progress = __is.readInt();
        members = SeqPublicPlayerHelper.read(__is);
    }
}
}

