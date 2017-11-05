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


public class TPetConfig
{
    public var code : int;

    public var name : String;

    public var level : int;

    public var type : int;

    public var model : int;

    public var avatar : int;

    public var growth : int;

    public var talent : String;

    public var volume : int;

    public var talentMax : int;

    public var skill1 : int;

    public var skill2 : int;

    public var skill3 : int;

    public function TPetConfig()
    {
    }
}
}
