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


public class TPlayer
{
    public var playerId : int;

    public var username : String;

    public var name : String;

    public var sex : int;

    public var camp : int;

    public var createDt : Date;

    public var career : int;

    public var level : int;

    public var server : String;

    public var platform : String;

    public var oldServerId : int;

    public var isMain : int;

    public var maxCombat : int;

    public var crossGame : int;

    public function TPlayer()
    {
    }
}
}
