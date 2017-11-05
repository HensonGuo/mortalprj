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


public class SBroadcast extends IMessageBase 
{
    public var area : int;

    public var type : int;

    public var code : int;

    [ArrayElementType("SMiniPlayer")]
    public var miniPlayers : Array;

    public var minLevel : int;

    public var msgKey : String;

    [ArrayElementType("String")]
    public var params : Array;

    public var content : String;

    public function SBroadcast(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBroadcast = new SBroadcast( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 101;

    override public function clone() : IMessageBase
    {
        return new SBroadcast;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(area);
        __os.writeInt(type);
        __os.writeInt(code);
        SeqMiniPlayerHelper.write(__os, miniPlayers);
        __os.writeInt(minLevel);
        __os.writeString(msgKey);
        SeqStringHelper.write(__os, params);
        __os.writeString(content);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        area = __is.readInt();
        type = __is.readInt();
        code = __is.readInt();
        miniPlayers = SeqMiniPlayerHelper.read(__is);
        minLevel = __is.readInt();
        msgKey = __is.readString();
        params = SeqStringHelper.read(__is);
        content = __is.readString();
    }
}
}

