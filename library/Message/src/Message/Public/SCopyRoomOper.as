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


public class SCopyRoomOper extends IMessageBase 
{
    public var copyCode : int;

    public var oper : int;

    public var leaderMapId : int;

    public var leaderX : int;

    public var leaderY : int;

    public function SCopyRoomOper(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SCopyRoomOper = new SCopyRoomOper( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 5003;

    override public function clone() : IMessageBase
    {
        return new SCopyRoomOper;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(copyCode);
        __os.writeInt(oper);
        __os.writeInt(leaderMapId);
        __os.writeInt(leaderX);
        __os.writeInt(leaderY);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        copyCode = __is.readInt();
        oper = __is.readInt();
        leaderMapId = __is.readInt();
        leaderX = __is.readInt();
        leaderY = __is.readInt();
    }
}
}
