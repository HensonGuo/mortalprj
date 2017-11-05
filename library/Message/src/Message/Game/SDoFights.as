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


public class SDoFights extends IMessageBase 
{
    [ArrayElementType("SDoFight")]
    public var doFights : Array;

    public function SDoFights(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDoFights = new SDoFights( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15954;

    override public function clone() : IMessageBase
    {
        return new SDoFights;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqDoFightHelper.write(__os, doFights);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        doFights = SeqDoFightHelper.read(__is);
    }
}
}

