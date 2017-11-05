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


public class TShopPanicBuy
{
    public var id : int;

    public var code : int;

    public var item1Index : int;

    public var item1Code : int;

    public var item1Price : int;

    public var item1LeftAmount : int;

    public var item2Index : int;

    public var item2Price : int;

    public var item2Code : int;

    public var item2LeftAmount : int;

    public var item3Index : int;

    public var item3Price : int;

    public var item3Code : int;

    public var item3LeftAmount : int;

    public var lastRecordDt : Date;

    public function TShopPanicBuy()
    {
    }
}
}
