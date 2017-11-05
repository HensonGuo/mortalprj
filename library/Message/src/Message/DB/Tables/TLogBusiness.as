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


public class TLogBusiness
{
    public var id : int;

    public var businessid : String;

    public var businessidentity : int;

    public var playerid : int;

    public var playername : String;

    public var status : int;

    public var coin : int;

    public var gold : int;

    public var items : String;

    public var logdt : Date;

    public function TLogBusiness()
    {
    }
}
}
