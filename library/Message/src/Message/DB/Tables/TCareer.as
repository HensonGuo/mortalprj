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


public class TCareer
{
    public var code : int;

    public var name : String;

    public var attackCareerFactor : int;

    public var attackType : int;

    public var attackSpeed : int;

    public var attackDistance : int;

    public var speed : int;

    public var initAttack : int;

    public var initLife : int;

    public var initMana : int;

    public var initPhysicalDefense : int;

    public var initMagicalDefense : int;

    public var initPenetration : int;

    public var initCrit : int;

    public var initToughness : int;

    public var initJouk : int;

    public var initHit : int;

    public var initExpertise : int;

    public var initBlock : int;

    public var initDamageReduce : int;

    public var addAttack : int;

    public var addLife : int;

    public var addMana : int;

    public var addPhysicalDefense : int;

    public var addMagicalDefense : int;

    public var addPenetration : int;

    public var addCrit : int;

    public var addToughness : int;

    public var addJouk : int;

    public var addHit : int;

    public var addExpertise : int;

    public var addBlock : int;

    public var addDamageReduce : int;

    public var maleBodySize : int;

    public var femaleBodySize : int;

    public function TCareer()
    {
    }
}
}
