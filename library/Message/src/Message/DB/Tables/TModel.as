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


public class TModel
{
    public var id : int;

    public var type : int;

    public var name : String;

    public var sortNum : int;

    public var test : int;

    public var mesh1 : String;

    public var texture1 : String;

    public var bone1 : String;

    public var mesh2 : String;

    public var texture2 : String;

    public var bone2 : String;

    public var mesh3 : String;

    public var texture3 : String;

    public var bone3 : String;

    public var mesh4 : String;

    public var texture4 : String;

    public var bone4 : String;

    public function TModel()
    {
    }
}
}
