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


public class SGuildWarehouseOut extends IMessageBase 
{
    public var entityId : SEntityId;

    public var item : SPlayerItem;

    public var moneyMap : Dictionary;

    public function SGuildWarehouseOut(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildWarehouseOut = new SGuildWarehouseOut( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16110;

    override public function clone() : IMessageBase
    {
        return new SGuildWarehouseOut;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        item.__write(__os);
        DictIntIntHelper.write(__os, moneyMap);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        item = new SPlayerItem();
        item.__read(__is);
        moneyMap = DictIntIntHelper.read(__is);
    }
}
}

