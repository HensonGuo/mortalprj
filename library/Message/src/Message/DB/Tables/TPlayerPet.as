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


public class TPlayerPet
{
    public var id : Number;

    public var playerId : int;

    public var uid : String;

    public var code : int;

    public var name : String;

    public var speciesName : String;

    public var lifeSpan : int;

    public var career : int;

    public var type : int;

    public var level : int;

    public var experience : Number;

    public var talent : int;

    public var talentMax : int;

    public var growth : int;

    public var model : int;

    public var avatar : int;

    public var life : int;

    public var mana : int;

    public var state : int;

    public var mode : int;

    public var bloodStr : String;

    public var bloodExp : int;

    public var growthMax : int;

    public var growthMaxGold : int;

    public var jsStr : String;

    public var lastDeadDt : Date;

    public function TPlayerPet()
    {
    }
}
}
