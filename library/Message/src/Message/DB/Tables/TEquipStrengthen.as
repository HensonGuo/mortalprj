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


public class TEquipStrengthen
{
    public var level : int;

    public var consumeItemCode : int;

    public var consumeItemAmount : int;

    public var consumeMoney : int;

    public var successProbability : int;

    public var mustFailedAmout : int;

    public var mustSuccessAmount : int;

    public var addPercent : int;

    public var rewardPercent : int;

    public function TEquipStrengthen()
    {
    }
}
}
