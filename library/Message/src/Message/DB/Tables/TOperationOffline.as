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


public class TOperationOffline
{
    public var id : Number;

    public var cmdType : int;

    public var cmdLevel : int;

    public var operObj : int;

    public var operValue : int;

    public var operValueEx : int;

    public var operString : String;

    public var operDate : Date;

    public function TOperationOffline()
    {
    }
}
}
