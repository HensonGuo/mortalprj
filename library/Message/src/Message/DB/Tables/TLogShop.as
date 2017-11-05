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


public class TLogShop
{
    public var id : Number;

    public var day : int;

    public var playerId : int;

    public var playerName : String;

    public var shopCode : int;

    public var itemCode : int;

    public var itemName : String;

    public var itemAmount : int;

    public var cost : int;

    public var unit : int;

    public var logDt : Date;

    public function TLogShop()
    {
    }
}
}
