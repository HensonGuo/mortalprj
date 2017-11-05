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


public class SGroupOper extends IMessageBase 
{
    public var type : int;

    public var fromEntityId : SEntityId;

    public var toEntityId : SEntityId;

    public var fromPlayer : SPublicPlayer;

    public var uid : String;

    public var groupName : String;

    public var memberNum : int;

    public function SGroupOper(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGroupOper = new SGroupOper( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 4002;

    override public function clone() : IMessageBase
    {
        return new SGroupOper;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        fromEntityId.__write(__os);
        toEntityId.__write(__os);
        fromPlayer.__write(__os);
        __os.writeString(uid);
        __os.writeString(groupName);
        __os.writeInt(memberNum);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        fromEntityId = new SEntityId();
        fromEntityId.__read(__is);
        toEntityId = new SEntityId();
        toEntityId.__read(__is);
        fromPlayer = new SPublicPlayer();
        fromPlayer.__read(__is);
        uid = __is.readString();
        groupName = __is.readString();
        memberNum = __is.readInt();
    }
}
}
