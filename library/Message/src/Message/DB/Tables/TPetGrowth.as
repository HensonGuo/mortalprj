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


public class TPetGrowth
{
    public var level : int;

    public var showRate : int;

    public var realRate : int;

    public var itemCode : int;

    public var amount : int;

    public var coin : int;

    public var gold : int;

    public var maxGold : int;

    public var add : int;

    public function TPetGrowth()
    {
    }
}
}
