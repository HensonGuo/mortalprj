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

import Message.Game.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SSeqSoul extends IMessageBase 
{
    public var soulDt : String;

    public var upgradeTime : int;

    public var ghost : int;

    public var nowSoul : int;

    [ArrayElementType("SSoul")]
    public var souls : Array;

    public function SSeqSoul(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SSeqSoul = new SSeqSoul( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15005;

    override public function clone() : IMessageBase
    {
        return new SSeqSoul;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(soulDt);
        __os.writeInt(upgradeTime);
        __os.writeInt(ghost);
        __os.writeInt(nowSoul);
        SeqSoulHelper.write(__os, souls);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        soulDt = __is.readString();
        upgradeTime = __is.readInt();
        ghost = __is.readInt();
        nowSoul = __is.readInt();
        souls = SeqSoulHelper.read(__is);
    }
}
}

