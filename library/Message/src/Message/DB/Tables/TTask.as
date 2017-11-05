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


public class TTask
{
    public var code : int;

    public var name : String;

    public var group : int;

    public var loopType : int;

    public var executeCount : int;

    public var canQuickComplete : int;

    public var getNpc : int;

    public var getDistance : int;

    public var endNpc : int;

    public var endDistance : int;

    public var getTalkId : int;

    public var endTalkId : int;

    public var notCompletedTalkId : int;

    public var getChoose : int;

    public var taskContextId : String;

    public var endChoose : int;

    public var guide : int;

    public var guideCompleted : int;

    public var failTalkId : int;

    public var effectType : int;

    public var effect1 : int;

    public var effect2 : String;

    public var getConditions : String;

    public var getGiveItemDict : String;

    public var completeCondition : String;

    public var endChooseItemDict : String;

    public var processJsStr : String;

    public var rewards : String;

    public var startTime : Date;

    public var endTime : Date;

    public var extendStr : String;

    public function TTask()
    {
    }
}
}
