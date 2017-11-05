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


public class TBoss
{
    public var code : int;

    public var name : String;

    public var level : int;

    public var force : int;

    public var type : int;

    public var attackMode : int;

    public var aiFight : int;

    public var aiFightFixedDamage : int;

    public var aiFightMaximumDamage : int;

    public var aiBehavior : int;

    public var aiBehaviorEscape : String;

    public var aiBehaviorFollow : String;

    public var aiBehaviorPath : int;

    public var npcId : int;

    public var avatarId : String;

    public var mesh : String;

    public var texture : String;

    public var bone : String;

    public var modelScale : int;

    public var bodyShape : int;

    public var bodySize : int;

    public var actionTime : int;

    public var speed : int;

    public var attackSpeed : int;

    public var attackDistance : int;

    public var sightRange : String;

    public var pursueRange : int;

    public var attackType : int;

    public var attack : int;

    public var maxLife : int;

    public var maxMana : int;

    public var physicalDefense : int;

    public var magicalDefense : int;

    public var penetration : int;

    public var crit : int;

    public var toughness : int;

    public var hit : int;

    public var jouk : int;

    public var block : int;

    public var expertise : int;

    public var damageReduce : int;

    public var crush : int;

    public var exp : int;

    public var skills : String;

    public var skillsGroup : String;

    public var globalCooldown : int;

    public var dropRule : int;

    public var dropBelong : int;

    public var dropShow : int;

    public var coinDrop : String;

    public var singleDrop1 : int;

    public var singleDrop2 : int;

    public var drop1 : int;

    public var drop2 : int;

    public var drop3 : int;

    public var drop4 : int;

    public var drop5 : int;

    public var drop6 : int;

    public var activeDrop1 : int;

    public var activeDrop2 : int;

    public var activeDrop3 : int;

    public var materialDrop : int;

    public var specialDrop : int;

    public var dialogId : int;

    public var existTime : int;

    public var category : int;

    public var triggerEvent : int;

    public var corpseTime : int;

    public function TBoss()
    {
    }
}
}
