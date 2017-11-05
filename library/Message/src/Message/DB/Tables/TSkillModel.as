// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.DB.Tables{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class TSkillModel
{
    public var id : int;

    public var action : String;

    public var leadAction : String;

    public var endAction : String;

    public var trackModel : String;

    public var selfModel : String;

    public var targetModel : String;

    public var daoguangModel : String;

    public var hitModel : String;

    public var isTargetDirection : int;

    public var isMultiple : int;

    public function TSkillModel()
    {
    }
}
}
