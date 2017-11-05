// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Message.Game.*;
import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class STask
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

    public var endChoose : int;

    public var guide : int;

    public var guideCompleted : int;

    public var failTalkId : int;

    public var context : String;

    public var processMap : Dictionary;

    public var effect : STaskEffect;

    [ArrayElementType("SConditon")]
    public var getConditions : Array;

    public var getGiveItemDict : Dictionary;

    [ArrayElementType("SConditon")]
    public var completeConditions : Array;

    public var endChooseItemDict : Dictionary;

    [ArrayElementType("STaskReward")]
    public var rewards : Array;

    public function STask()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(code);
        __os.writeString(name);
        __os.writeInt(group);
        __os.writeInt(loopType);
        __os.writeInt(executeCount);
        __os.writeInt(canQuickComplete);
        __os.writeInt(getNpc);
        __os.writeInt(getDistance);
        __os.writeInt(endNpc);
        __os.writeInt(endDistance);
        __os.writeInt(getTalkId);
        __os.writeInt(endTalkId);
        __os.writeInt(notCompletedTalkId);
        __os.writeInt(getChoose);
        __os.writeInt(endChoose);
        __os.writeInt(guide);
        __os.writeInt(guideCompleted);
        __os.writeInt(failTalkId);
        __os.writeString(context);
        DictSeqProcessHelper.write(__os, processMap);
        effect.__write(__os);
        SeqConditonHelper.write(__os, getConditions);
        DictIntIntHelper.write(__os, getGiveItemDict);
        SeqConditonHelper.write(__os, completeConditions);
        DictIntIntHelper.write(__os, endChooseItemDict);
        SeqTaskRewardHelper.write(__os, rewards);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        code = __is.readInt();
        name = __is.readString();
        group = __is.readInt();
        loopType = __is.readInt();
        executeCount = __is.readInt();
        canQuickComplete = __is.readInt();
        getNpc = __is.readInt();
        getDistance = __is.readInt();
        endNpc = __is.readInt();
        endDistance = __is.readInt();
        getTalkId = __is.readInt();
        endTalkId = __is.readInt();
        notCompletedTalkId = __is.readInt();
        getChoose = __is.readInt();
        endChoose = __is.readInt();
        guide = __is.readInt();
        guideCompleted = __is.readInt();
        failTalkId = __is.readInt();
        context = __is.readString();
        processMap = DictSeqProcessHelper.read(__is);
        effect = new STaskEffect();
        effect.__read(__is);
        getConditions = SeqConditonHelper.read(__is);
        getGiveItemDict = DictIntIntHelper.read(__is);
        completeConditions = SeqConditonHelper.read(__is);
        endChooseItemDict = DictIntIntHelper.read(__is);
        rewards = SeqTaskRewardHelper.read(__is);
    }
}
}

