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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SLoginReturn
{
    public var playerId : int;

    public var name : String;

    public var sessionKey : SSessionKey;

    [ArrayElementType("SUrl")]
    public var urls : Array;

    public function SLoginReturn()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(playerId);
        __os.writeString(name);
        sessionKey.__write(__os);
        SeqUrlHelper.write(__os, urls);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        playerId = __is.readInt();
        name = __is.readString();
        sessionKey = new SSessionKey();
        sessionKey.__read(__is);
        urls = SeqUrlHelper.read(__is);
    }
}
}

