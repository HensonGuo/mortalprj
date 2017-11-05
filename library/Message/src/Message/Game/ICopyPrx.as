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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public interface ICopyPrx 
{
    function enterHall_async( __cb : AMI_ICopy_enterHall, copyCode : int ) : void ;

    function leftHall_async( __cb : AMI_ICopy_leftHall) : void ;

    function viewGroup_async( __cb : AMI_ICopy_viewGroup, copyCode : int ) : void ;

    function enterCopy_async( __cb : AMI_ICopy_enterCopy, copyCode : int ) : void ;

    function reEnterCopy_async( __cb : AMI_ICopy_reEnterCopy) : void ;

    function leftCopy_async( __cb : AMI_ICopy_leftCopy) : void ;

    function copyWaitingRoomOper_async( __cb : AMI_ICopy_copyWaitingRoomOper, copyCode : int , oper : int ) : void ;

    function getCopyWaitingRoomInfo_async( __cb : AMI_ICopy_getCopyWaitingRoomInfo, copyCode : int ) : void ;
}
}
