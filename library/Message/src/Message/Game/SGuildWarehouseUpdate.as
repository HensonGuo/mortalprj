// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SGuildWarehouseUpdate extends IMessageBase 
{
    [ArrayElementType("SPlayerItem")]
    public var items : Array;

    public var moneyMap : Dictionary;

    public function SGuildWarehouseUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildWarehouseUpdate = new SGuildWarehouseUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16109;

    override public function clone() : IMessageBase
    {
        return new SGuildWarehouseUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqPlayerItemHelper.write(__os, items);
        DictIntIntHelper.write(__os, moneyMap);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        items = SeqPlayerItemHelper.read(__is);
        moneyMap = DictIntIntHelper.read(__is);
    }
}
}

