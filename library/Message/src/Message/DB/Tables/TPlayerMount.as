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


public class TPlayerMount
{
    public var id : Number;

    public var playerId : int;

    public var uid : String;

    public var code : int;

    public var level : int;

    public var experience : Number;

    public var tool : String;

    public var state : int;

    public var expNum : int;

    public var lastExpDt : Date;

    public var jsStr : String;

    public function TPlayerMount()
    {
    }
}
}
