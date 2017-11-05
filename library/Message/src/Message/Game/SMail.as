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


public class SMail
{
    public var mailId : Number;

    public var fromPlayerId : int;

    public var fromPlayerName : String;

    public var toPlayerId : int;

    public var toPlayerName : String;

    public var title : String;

    public var content : String;

    public var attachmentCoin : int;

    public var attachmentGold : int;

    public var mailDt : Date;

    public var type : int;

    public var status : int;

    public var hadAttachment : int;

    [ArrayElementType("SPlayerItem")]
    public var playerItems : Array;

    public function SMail()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeLong(mailId);
        __os.writeInt(fromPlayerId);
        __os.writeString(fromPlayerName);
        __os.writeInt(toPlayerId);
        __os.writeString(toPlayerName);
        __os.writeString(title);
        __os.writeString(content);
        __os.writeInt(attachmentCoin);
        __os.writeInt(attachmentGold);
        __os.writeDate(mailDt);
        __os.writeInt(type);
        __os.writeInt(status);
        __os.writeInt(hadAttachment);
        SeqPlayerItemHelper.write(__os, playerItems);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        mailId = __is.readLong();
        fromPlayerId = __is.readInt();
        fromPlayerName = __is.readString();
        toPlayerId = __is.readInt();
        toPlayerName = __is.readString();
        title = __is.readString();
        content = __is.readString();
        attachmentCoin = __is.readInt();
        attachmentGold = __is.readInt();
        mailDt = __is.readDate();
        type = __is.readInt();
        status = __is.readInt();
        hadAttachment = __is.readInt();
        playerItems = SeqPlayerItemHelper.read(__is);
    }
}
}

