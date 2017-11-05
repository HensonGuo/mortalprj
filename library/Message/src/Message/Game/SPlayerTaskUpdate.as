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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPlayerTaskUpdate
{
    public var taskCode : int;

    public var status : int;

    public var currentSetp : int;

    [ArrayElementType("int")]
    public var stepRecords : Array;

    public function SPlayerTaskUpdate()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(taskCode);
        __os.writeInt(status);
        __os.writeInt(currentSetp);
        SeqIntHelper.write(__os, stepRecords);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        taskCode = __is.readInt();
        status = __is.readInt();
        currentSetp = __is.readInt();
        stepRecords = SeqIntHelper.read(__is);
    }
}
}

