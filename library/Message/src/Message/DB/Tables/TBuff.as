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


public class TBuff
{
    public var buffId : int;

    public var name : String;

    public var symbol : int;

    public var set : int;

    public var group : int;

    public var type : int;

    public var gainOrLoss : int;

    public var level : int;

    public var rate : int;

    public var effect : int;

    public var effectEx : int;

    public var isValue : int;

    public var effectCount : int;

    public var lastTime : int;

    public var timeType : int;

    public var overLay : int;

    public var removeType : int;

    public var description : String;

    public var icon : int;

    public var specialEffectId : String;

    public function TBuff()
    {
    }
}
}
