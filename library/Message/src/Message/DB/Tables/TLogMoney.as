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


public class TLogMoney
{
    public var id : Number;

    public var day : int;

    public var playerId : int;

    public var playerName : String;

    public var operType : int;

    public var operCode : int;

    public var operDetail : String;

    public var updateUnit : int;

    public var updateMoney : int;

    public var oldMoney : int;

    public var newMoney : int;

    public var logDt : Date;

    public var playerLevel : int;

    public function TLogMoney()
    {
    }
}
}
