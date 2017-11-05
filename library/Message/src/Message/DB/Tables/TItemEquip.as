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


public class TItemEquip
{
    public var code : int;

    public var icon : String;

    public var dropIcon : String;

    public var codeUnbind : int;

    public var name : String;

    public var group : int;

    public var category : int;

    public var type : int;

    public var level : int;

    public var itemLevel : int;

    public var effect : int;

    public var effectEx : int;

    public var bind : int;

    public var career : int;

    public var sell : int;

    public var sellPrice : int;

    public var sellUnit : int;

    public var color : int;

    public var overlay : int;

    public var existTime : int;

    public var existSpecial : int;

    public var cdTime : int;

    public var useType : int;

    public var descStr : String;

    public var attack : int;

    public var life : int;

    public var mana : int;

    public var physDefense : int;

    public var magicDefense : int;

    public var penetration : int;

    public var hit : int;

    public var jouk : int;

    public var crit : int;

    public var toughness : int;

    public var expertise : int;

    public var block : int;

    public var damageReduce : int;

    public var damageDeepPercent : int;

    public var damageLowerPercent : int;

    public var refineAttack : int;

    public var refineLife : int;

    public var refineMana : int;

    public var refinePhysicalDefense : int;

    public var refineMagicalDefense : int;

    public var refinePenetration : int;

    public var refineHit : int;

    public var refineJouk : int;

    public var refineCrit : int;

    public var refineToughness : int;

    public var refineExpertise : int;

    public var refineBlock : int;

    public var refineDamageReduce : int;

    public var harmDeeper : int;

    public var harmLower : int;

    public var qualityRandomMin : int;

    public var qualityRandomMax : int;

    public var qualityLimited : int;

    public var holeNum : int;

    public var wastageType : int;

    public var repairType : int;

    public var durable : int;

    public var repairItemCode : int;

    public var repairItemNum : int;

    public var suitId : int;

    public var suitGroup : int;

    public var modelId : int;

    public var hunqiFeed : int;

    public var feedMount : int;

    public var market : int;

    public var beginTime : Date;

    public var endTime : Date;

    public var control : int;

    public var test : int;

    public var skill : String;

    public function TItemEquip()
    {
    }
}
}
