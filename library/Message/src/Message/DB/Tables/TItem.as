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


public class TItem
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

    public var career : int;

    public var bind : int;

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

    public var feedMount : int;

    public var hunqiFeed : int;

    public var market : int;

    public var beginTime : Date;

    public var endTime : Date;

    public var control : int;

    public var test : int;

    public function TItem()
    {
    }
}
}
