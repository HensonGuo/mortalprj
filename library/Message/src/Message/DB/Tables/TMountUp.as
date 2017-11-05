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


public class TMountUp
{
    public var level : int;

    public var experience : int;

    public var attack : int;

    public var life : int;

    public var physDefense : int;

    public var magicDefense : int;

    public var speed : int;

    public var addSpeed : int;

    public function TMountUp()
    {
    }
}
}
