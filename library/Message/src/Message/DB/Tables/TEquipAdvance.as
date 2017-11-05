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


public class TEquipAdvance
{
    public var id : int;

    public var recordType : String;

    public var suitGroup : int;

    public var targetSuitGroup : int;

    public var consumeMoney : int;

    public var consumeItem : String;

    public var equipAttackDefense : int;

    public var equipLevel : int;

    public var equipQuality : int;

    public var qualityAddPercent : int;

    public function TEquipAdvance()
    {
    }
}
}
