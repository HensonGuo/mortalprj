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



public interface IMountPrx 
{
    function getPlayerMountInfo_async( __cb : AMI_IMount_getPlayerMountInfo) : void ;

    function setMountState_async( __cb : AMI_IMount_setMountState, uid : String , state : EMountState ) : void ;

    function upgrade_async( __cb : AMI_IMount_upgrade, uid : String , type : int , itemCount : int , goldCount : int ) : void ;

    function upgradeTool_async( __cb : AMI_IMount_upgradeTool, uid : String , type : int , itemCount : int , goldCount : int ) : void ;
}
}

