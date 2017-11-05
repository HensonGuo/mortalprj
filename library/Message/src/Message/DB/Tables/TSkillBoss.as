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


public class TSkillBoss
{
    public var skillId : int;

    public var name : String;

    public var type : int;

    public var hurtEffect : int;

    public var hurtEffectEx : int;

    public var specialEffect : int;

    public var targetType : int;

    public var distance : int;

    public var targetSelect : int;

    public var rangeType : int;

    public var range : String;

    public var goalNum : int;

    public var targetEntityType : int;

    public var consume : int;

    public var triggerType : int;

    public var triggerRate : int;

    public var hitRate : int;

    public var leadTime : int;

    public var leadCount : int;

    public var useTime : int;

    public var delayTime : int;

    public var specialCorrespondingBuff : String;

    public var correspondingEffect : String;

    public var additionRate : int;

    public var additionBuff : int;

    public var additionBuff2 : int;

    public var nextSkill : int;

    public var switchSkillBuff : int;

    public var switchSkill : int;

    public var cooldownTime : int;

    public var hatred : int;

    public var ignoreBuff : int;

    public var affectCdType : int;

    public var posType : int;

    public var skillLevel : int;

    public var skillDescription : String;

    public var skillIcon : int;

    public var skillModel : int;

    public function TSkillBoss()
    {
    }
}
}
