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


public class SPlayerTask
{
    public var task : STask;

    public var createDt : Date;

    public var executeCount : int;

    public var status : int;

    public var extend : int;

    public var currentStep : int;

    [ArrayElementType("int")]
    public var stepRecords : Array;

    public function SPlayerTask()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        task.__write(__os);
        __os.writeDate(createDt);
        __os.writeInt(executeCount);
        __os.writeInt(status);
        __os.writeInt(extend);
        __os.writeInt(currentStep);
        SeqIntHelper.write(__os, stepRecords);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        task = new STask();
        task.__read(__is);
        createDt = __is.readDate();
        executeCount = __is.readInt();
        status = __is.readInt();
        extend = __is.readInt();
        currentStep = __is.readInt();
        stepRecords = SeqIntHelper.read(__is);
    }
}
}

