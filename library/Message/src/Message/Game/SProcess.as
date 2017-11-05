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


public class SProcess
{
    public var type : int;

    public var code : int;

    [ArrayElementType("int")]
    public var contents : Array;

    public function SProcess()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        __os.writeInt(code);
        SeqIntHelper.write(__os, contents);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        code = __is.readInt();
        contents = SeqIntHelper.read(__is);
    }
}
}

