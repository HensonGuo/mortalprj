// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.BroadCast{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SEntityIdInfo extends IMessageBase 
{
    public var entityId : SEntityId;

    public function SEntityIdInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SEntityIdInfo = new SEntityIdInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 11005;

    override public function clone() : IMessageBase
    {
        return new SEntityIdInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
    }
}
}

