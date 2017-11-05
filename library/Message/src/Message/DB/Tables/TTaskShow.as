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


public class TTaskShow
{
    public var id : int;

    public var taskId : int;

    public var taskStep : int;

    public var hideNpcList : String;

    public var showNpcList : String;

    public var hideBossList : String;

    public var showBossList : String;

    public var hideCopyList : String;

    public var showCopyList : String;

    public var npcToBoss : String;

    public var bossToNpc : String;

    public function TTaskShow()
    {
    }
}
}
