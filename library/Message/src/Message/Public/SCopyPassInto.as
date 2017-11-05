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


public class SCopyPassInto extends IMessageBase 
{
    public var copyCode : int;

    public var mapId : int;

    public var point : SPoint;

    public function SCopyPassInto(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SCopyPassInto = new SCopyPassInto( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 5002;

    override public function clone() : IMessageBase
    {
        return new SCopyPassInto;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(copyCode);
        __os.writeInt(mapId);
        point.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        copyCode = __is.readInt();
        mapId = __is.readInt();
        point = new SPoint();
        point.__read(__is);
    }
}
}
