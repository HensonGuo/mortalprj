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


public class TPlayerEscort
{
    public var id : Number;

    public var playerId : int;

    public var type : int;

    public var code : int;

    public var map : int;

    public var x : int;

    public var y : int;

    public var toMap : int;

    public var toX : int;

    public var toY : int;

    public var startDt : Date;

    public var extraValue : int;

    public function TPlayerEscort()
    {
    }
}
}
