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


public class TShopSell
{
    public var shopCode : int;

    public var itemCode : int;

    public var price : int;

    public var offer : int;

    public var label : int;

    public var activeOffer : int;

    public var broadcast : int;

    public var canSell : int;

    public var maxLevelLimit : int;

    public var minLevelLimit : int;

    public var startDt : Date;

    public var endDt : Date;

    public var maxBuyLimit : int;

    public var maxBuyLimitDay : int;

    public function TShopSell()
    {
    }
}
}
