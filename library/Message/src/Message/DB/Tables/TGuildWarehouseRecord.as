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


public class TGuildWarehouseRecord
{
    public var id : int;

    public var guildId : int;

    public var startName : String;

    public var endName : String;

    public var itemCode : int;

    public var amount : int;

    public var uint : int;

    public var oper : int;

    public var operDt : Date;

    public function TGuildWarehouseRecord()
    {
    }
}
}
