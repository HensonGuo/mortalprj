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


public class SBroadcastGroupIdUpdate extends IMessageBase 
{
    public var updateEntityId : SEntityId;

    public var groupId : SEntityId;

    public function SBroadcastGroupIdUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBroadcastGroupIdUpdate = new SBroadcastGroupIdUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 4004;

    override public function clone() : IMessageBase
    {
        return new SBroadcastGroupIdUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        updateEntityId.__write(__os);
        groupId.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updateEntityId = new SEntityId();
        updateEntityId.__read(__is);
        groupId = new SEntityId();
        groupId.__read(__is);
    }
}
}
