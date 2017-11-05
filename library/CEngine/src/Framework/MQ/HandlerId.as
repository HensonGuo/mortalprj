// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Framework.MQ{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;


//[Bindable]
public class HandlerId
{
    public var type : int;
	public var typeEx : int;
	public var typeEx2 : int;
    public var id : int;
	

    public function HandlerId()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte(type);
		__os.writeShort(typeEx);
		__os.writeByte( typeEx2 );
        __os.writeInt(id);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readByte();
		typeEx = __is.readShort();
		typeEx2 = __is.readByte();
        id = __is.readInt();
    }
}
}
