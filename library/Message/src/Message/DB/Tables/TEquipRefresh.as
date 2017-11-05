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


public class TEquipRefresh
{
    public var recordType : String;

    public var equipLevel : int;

    public var equipRefreshItemcode : int;

    public var equipRefreshConsumeMoney : int;

    public var equipMaxStarLevel : int;

    public var equipStarLevelProbability : String;

    public var equipRefreshMinStar : String;

    public var equipDecomposeItemcode : int;

    public var equipDecomposeMoney : int;

    public var fightAttrType : int;

    public var fightAttrProbability : int;

    public var fightAttrEffect : int;

    public var refreshNum : int;

    public var refreshNumProbability : int;

    public var starLevel : int;

    public var starEffectTimes : int;

    public var colorLowbound : int;

    public var colorUpbound : int;

    public var color : int;

    public function TEquipRefresh()
    {
    }
}
}
