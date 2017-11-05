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


public class TTaskDialog
{
    public var id : int;

    public var talkStr : String;

    public var showStr : String;

    public var poetry : String;

    public var screenNpcList : String;

    public var showNpcList : String;

    public var screenBossList : String;

    public var showBossList : String;

    public var screenCopyList : String;

    public var showCopyList : String;

    public var dramaIntroduce : String;

    public function TTaskDialog()
    {
    }
}
}
