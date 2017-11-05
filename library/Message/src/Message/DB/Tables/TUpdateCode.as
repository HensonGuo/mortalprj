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


public class TUpdateCode
{
    public var updateCode : int;

    public var updateName : String;

    public var updateStr : String;

    public var isConsPro : int;

    public var ckConsPro : int;

    public var outUpdateStr : String;

    public var isDayCost : int;

    public var isStIncome : int;

    public function TUpdateCode()
    {
    }
}
}
