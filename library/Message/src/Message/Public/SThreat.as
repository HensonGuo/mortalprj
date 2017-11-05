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


public class SThreat
{
    public var entityId : SEntityId;

    public var name : String;

    public var value : int;

    public function SThreat()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        __os.writeString(name);
        __os.writeInt(value);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        name = __is.readString();
        value = __is.readInt();
    }
}
}
