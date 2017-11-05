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


public class TNpc
{
    public var code : int;

    public var camp : int;

    public var level : String;

    public var name : String;

    public var careerName : String;

    public var talk : String;

    public var topTalk : String;

    public var effect : String;

    public var effectTittle : String;

    public var sound : String;

    public var bossId : int;

    public var mesh : String;

    public var texture : String;

    public var bone : String;

    public var avtar : int;

    public var headTitle : String;

    public var type : int;

    public var direction : int;

    public var modelScale : int;

    public function TNpc()
    {
    }
}
}
