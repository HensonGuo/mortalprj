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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SNpcTask
{
    public var status : int;

    public var extend : int;

    public var task : STask;

    public function SNpcTask()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(status);
        __os.writeInt(extend);
        task.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        status = __is.readInt();
        extend = __is.readInt();
        task = new STask();
        task.__read(__is);
    }
}
}
