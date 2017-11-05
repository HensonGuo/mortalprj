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


public class SPublicEscort extends IMessageBase 
{
    public var code : int;

    public var type : int;

    public var toMap : int;

    public var toPoint : SPoint;

    public function SPublicEscort(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPublicEscort = new SPublicEscort( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 85;

    override public function clone() : IMessageBase
    {
        return new SPublicEscort;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(code);
        __os.writeInt(type);
        __os.writeInt(toMap);
        toPoint.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        code = __is.readInt();
        type = __is.readInt();
        toMap = __is.readInt();
        toPoint = new SPoint();
        toPoint.__read(__is);
    }
}
}
