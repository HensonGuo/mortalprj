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


public class SBossRefresh
{
    public var plan : int;

    public var order : int;

    public var point : SPoint;

    [ArrayElementType("int")]
    public var bosses : Array;

    public function SBossRefresh()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(plan);
        __os.writeInt(order);
        point.__write(__os);
        SeqIntHelper.write(__os, bosses);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        plan = __is.readInt();
        order = __is.readInt();
        point = new SPoint();
        point.__read(__is);
        bosses = SeqIntHelper.read(__is);
    }
}
}
