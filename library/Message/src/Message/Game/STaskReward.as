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


public class STaskReward
{
    public var reward : SReward;

    public var levelMin : int;

    public var levelMax : int;

    public var career : int;

    public function STaskReward()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        reward.__write(__os);
        __os.writeInt(levelMin);
        __os.writeInt(levelMax);
        __os.writeInt(career);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        reward = new SReward();
        reward.__read(__is);
        levelMin = __is.readInt();
        levelMax = __is.readInt();
        career = __is.readInt();
    }
}
}

