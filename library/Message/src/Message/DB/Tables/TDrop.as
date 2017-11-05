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


public class TDrop
{
    public var id : int;

    public var name : String;

    public var count : int;

    public var type : int;

    public var dropStr : String;

    public var startDt : Date;

    public var endDt : Date;

    public var dropLevel : int;

    public var maxDropLevel : int;

    public function TDrop()
    {
    }
}
}
