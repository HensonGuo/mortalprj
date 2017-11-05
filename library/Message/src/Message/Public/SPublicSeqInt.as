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


public class SPublicSeqInt extends IMessageBase 
{
    [ArrayElementType("int")]
    public var publicSeqInt : Array;

    public function SPublicSeqInt(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicSeqInt = new SPublicSeqInt( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 106;

    override public function clone() : IMessageBase
    {
        return new SPublicSeqInt;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqIntHelper.write(__os, publicSeqInt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        publicSeqInt = SeqIntHelper.read(__is);
    }
}
}
