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


public class TRune
{
    public var runeId : int;

    public var name : String;

    public var career : int;

    public var level : int;

    public var effectSkill : int;

    public var effectBuff : int;

    public var effectField : int;

    public var effectValue : String;

    public var skillBelong : int;

    public var skillBelongLevel : int;

    public var runePos : int;

    public var item : int;

    public var exp : int;

    public var coin : int;

    public var runicPower : int;

    public var description : String;

    public var icon : String;

    public function TRune()
    {
    }
}
}
