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


public class SCustomPoint extends IMessageBase 
{
    public var index : int;

    public var name : String;

    public var mapId : int;

    public var point : SPoint;

    public function SCustomPoint(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SCustomPoint = new SCustomPoint( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 33;

    override public function clone() : IMessageBase
    {
        return new SCustomPoint;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(index);
        __os.writeString(name);
        __os.writeInt(mapId);
        point.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        index = __is.readInt();
        name = __is.readString();
        mapId = __is.readInt();
        point = new SPoint();
        point.__read(__is);
    }
}
}
