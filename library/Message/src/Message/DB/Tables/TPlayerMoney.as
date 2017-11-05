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


public class TPlayerMoney
{
    public var id : Number;

    public var playerId : int;

    public var coin : int;

    public var coinBind : int;

    public var gold : int;

    public var goldBind : int;

    public var vitalEnergy : int;

    public var honour : int;

    public var arena : int;

    public var prestige : int;

    public var glamour : int;

    public var contributeUnion : int;

    public var morality : int;

    public var point : int;

    public var fightEnergy : int;

    public var runicPower : int;

    public function TPlayerMoney()
    {
    }
}
}
