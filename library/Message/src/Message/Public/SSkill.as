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


public class SSkill
{
    public var skillId : int;

    public var cdDt : Date;

    public var pos : int;

    public function SSkill()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(skillId);
        __os.writeDate(cdDt);
        __os.writeInt(pos);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        skillId = __is.readInt();
        cdDt = __is.readDate();
        pos = __is.readInt();
    }
}
}
