// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Engine.RMI{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;



public interface IKeepActivePrx 
{
    function keepActive_async( __cb : AMI_IKeepActive_keepActive) : void ;
}
}
