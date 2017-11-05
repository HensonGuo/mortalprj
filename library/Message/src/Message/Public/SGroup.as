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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SGroup extends IMessageBase 
{
    public var name : String;

    public var groupId : SEntityId;

    public var captainId : SEntityId;

    [ArrayElementType("SGroupPlayer")]
    public var players : Array;

    public var memberInvite : Boolean;

    public var autoEnter : Boolean;

    public function SGroup(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGroup = new SGroup( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 4000;

    override public function clone() : IMessageBase
    {
        return new SGroup;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(name);
        groupId.__write(__os);
        captainId.__write(__os);
        SeqGroupPlayerHelper.write(__os, players);
        __os.writeBool(memberInvite);
        __os.writeBool(autoEnter);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        name = __is.readString();
        groupId = new SEntityId();
        groupId.__read(__is);
        captainId = new SEntityId();
        captainId.__read(__is);
        players = SeqGroupPlayerHelper.read(__is);
        memberInvite = __is.readBool();
        autoEnter = __is.readBool();
    }
}
}

