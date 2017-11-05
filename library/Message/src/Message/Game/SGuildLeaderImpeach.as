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


public class SGuildLeaderImpeach extends IMessageBase 
{
    public var guildId : int;

    public var impeachType : int;

    public var endDate : Date;

    public var leaderName : String;

    public var fromPlayer : String;

    public var extend : int;

    public function SGuildLeaderImpeach(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildLeaderImpeach = new SGuildLeaderImpeach( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 16104;

    override public function clone() : IMessageBase
    {
        return new SGuildLeaderImpeach;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(guildId);
        __os.writeInt(impeachType);
        __os.writeDate(endDate);
        __os.writeString(leaderName);
        __os.writeString(fromPlayer);
        __os.writeInt(extend);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        guildId = __is.readInt();
        impeachType = __is.readInt();
        endDate = __is.readDate();
        leaderName = __is.readString();
        fromPlayer = __is.readString();
        extend = __is.readInt();
    }
}
}
