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


public class TLogItem
{
    public var id : Number;

    public var day : int;

    public var playerId : int;

    public var playerName : String;

    public var operType : int;

    public var operCode : int;

    public var operDetail : String;

    public var playerItemUid : String;

    public var itemCode : int;

    public var itemName : String;

    public var updateAmount : int;

    public var oldAmount : int;

    public var newAmount : int;

    public var logDt : Date;

    public function TLogItem()
    {
    }
}
}
