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


public class SMaxProcess
{
    public var copyCode : int;

    public var difficulty : int;

    public var process : int;

    public function SMaxProcess()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(copyCode);
        __os.writeInt(difficulty);
        __os.writeInt(process);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        copyCode = __is.readInt();
        difficulty = __is.readInt();
        process = __is.readInt();
    }
}
}
