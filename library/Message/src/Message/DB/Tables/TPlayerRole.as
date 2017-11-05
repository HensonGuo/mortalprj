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


public class TPlayerRole
{
    public var id : int;

    public var playerId : int;

    public var level : int;

    public var experience : Number;

    public var career : int;

    public var life : int;

    public var mana : int;

    public var stamina : int;

    public var energy : int;

    public var resetEnergyDt : Date;

    public function TPlayerRole()
    {
    }
}
}
