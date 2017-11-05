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


public class TPlayerExtend
{
    public var id : int;

    public var playerId : int;

    public var flag : int;

    public var isLock : int;

    public var forbidTalk : int;

    public var canTalkDt : Date;

    public var setModeDt : Date;

    public var mode : int;

    public var status : int;

    public var usedPromotionCardType : Number;

    public var signature : String;

    public function TPlayerExtend()
    {
    }
}
}
