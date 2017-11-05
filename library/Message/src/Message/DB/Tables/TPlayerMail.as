// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.DB.Tables{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class TPlayerMail
{
    public var id : Number;

    public var fromPlayerId : int;

    public var fromPlayerName : String;

    public var toPlayerId : int;

    public var toPlayerName : String;

    public var type : int;

    public var status : int;

    public var title : String;

    public var content : String;

    public var hadAttachment : int;

    public var attachmentCoinBind : int;

    public var attachmentCoin : int;

    public var attachmentGoldBind : int;

    public var attachmentGold : int;

    public var attachmentItems : String;

    public var mailDt : Date;

    public var updateCode : int;

    public function TPlayerMail()
    {
    }
}
}
