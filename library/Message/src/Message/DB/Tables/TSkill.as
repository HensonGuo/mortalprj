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


public class TSkill
{
    public var skillId : int;

    public var name : String;

    public var career : int;

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

    public var additionBuff2 : String;

    public var nextSkill : int;

    public var combo : String;

    public var switchSkillBuff : int;

    public var switchSkill : int;

    public var cooldownTime : int;

    public var publicCdTime : int;

    public var hatred : int;

    public var ignoreBuff : int;

    public var affectCdType : int;

    public var correspondingWeapon : int;

    public var posType : int;

    public var series : int;

    public var preSkills : String;

    public var skillLevel : int;

    public var levelLimit : int;

    public var consumeMaterial : String;

    public var needSkillBook : int;

    public var needExperience : int;

    public var needCoin : int;

    public var needVitalEnergy : int;

    public var skillDescription : String;

    public var skillIcon : int;

    public var skillModel : int;

    public var guildSchoolLevel : int;

    public var needGuildContribute : int;

    public var hookType : int;

    public var textDirection : int;

    public function TSkill()
    {
    }
}
}
