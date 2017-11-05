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


public class TPlayerSoulUp
{
    public var soul : int;

    public var name : String;

    public var level : int;

    public var holeId : int;

    public var holeName : String;

    public var time : int;

    public var exp : int;

    public var money : int;

    public var attack : int;

    public var life : int;

    public var physDefense : int;

    public var magicDefence : int;

    public var penetration : int;

    public var crit : int;

    public var toughness : int;

    public var jouk : int;

    public var hit : int;

    public var expertise : int;

    public var block : int;

    public function TPlayerSoulUp()
    {
    }
}
}
