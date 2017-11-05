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


public class TPublicNotice
{
    public var id : Number;

    public var type : int;

    public var startTime : Date;

    public var endTime : Date;

    public var bcInterval : int;

    public var content : String;

    public var status : int;

    public var autoMessage : int;

    public function TPublicNotice()
    {
    }
}
}
