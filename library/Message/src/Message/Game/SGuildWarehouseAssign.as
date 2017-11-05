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


public class SGuildWarehouseAssign extends IMessageBase 
{
    public var toEntityId : SEntityId;

    [ArrayElementType("SPlayerItem")]
    public var items : Array;

    public var state : EGuildWarehouseState;

    public function SGuildWarehouseAssign(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildWarehouseAssign = new SGuildWarehouseAssign( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16112;

    override public function clone() : IMessageBase
    {
        return new SGuildWarehouseAssign;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        toEntityId.__write(__os);
        SeqPlayerItemHelper.write(__os, items);
        state.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        toEntityId = new SEntityId();
        toEntityId.__read(__is);
        items = SeqPlayerItemHelper.read(__is);
        state = EGuildWarehouseState.__read(__is);
    }
}
}

