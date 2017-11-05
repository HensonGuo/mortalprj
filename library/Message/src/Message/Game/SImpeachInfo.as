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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SImpeachInfo extends IMessageBase 
{
    public var impeachPlayerId : int;

    public var impeachedPlayerId : int;

    public function SImpeachInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SImpeachInfo = new SImpeachInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15202;

    override public function clone() : IMessageBase
    {
        return new SImpeachInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(impeachPlayerId);
        __os.writeInt(impeachedPlayerId);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        impeachPlayerId = __is.readInt();
        impeachedPlayerId = __is.readInt();
    }
}
}
