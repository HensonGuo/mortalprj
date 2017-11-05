// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SBusinessItemUpdate extends IMessageBase 
{
    public var updateType : EUpdateType;

    public var index : int;

    public var playerItem : SPlayerItem;

    public function SBusinessItemUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBusinessItemUpdate = new SBusinessItemUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 13500;

    override public function clone() : IMessageBase
    {
        return new SBusinessItemUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        updateType.__write(__os);
        __os.writeInt(index);
        playerItem.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updateType = EUpdateType.__read(__is);
        index = __is.readInt();
        playerItem = new SPlayerItem();
        playerItem.__read(__is);
    }
}
}
