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


public class TCopy
{
    public var code : int;

    public var group : int;

    public var name : String;

    public var enterMinLevel : int;

    public var enterMaxLevel : int;

    public var playerMin : int;

    public var playerMax : int;

    public var openTime : String;

    public var dayNum : int;

    public var stayTime : int;

    public var maps : String;

    public var intoMapId : int;

    public var intoX : int;

    public var intoY : int;

    public var rewardValue : int;

    public var rewardShow : String;

    public var mode : int;

    public var successCondition : int;

    public var successValue : String;

    public var failCondition : int;

    public var failValue : String;

    public var type : int;

    public var npc : int;

    public var offlineExp : String;

    public var delayExp : int;

    public var cost : int;

    public var costUnit : int;

    public var allianceLevel : int;

    public var minWorldLevel : int;

    public var maxWorldLevel : int;

    public var dropShare : int;

    public var processJudge : String;

    public var processAll : int;

    public var quickQuit : int;

    public var desc : String;

    public var bossShow : String;

    public function TCopy()
    {
    }
}
}
