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


public class TShopPanicBuyShop
{
    public var code : int;

    public var panicBuyShopCode : int;

    public var panicBuyType : int;

    public var sellItemAmount : int;

    public var getItemType : int;

    public var beginTime : Date;

    public var endTime : Date;

    public var description : String;

    public function TShopPanicBuyShop()
    {
    }
}
}
