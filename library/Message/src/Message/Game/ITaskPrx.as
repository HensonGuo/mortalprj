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



public interface ITaskPrx 
{
    function npcTask_async( __cb : AMI_ITask_npcTask, npc : int ) : void ;

    function talkToNpc_async( __cb : AMI_ITask_talkToNpc, taskCode : int , npc : int , code : int ) : void ;

    function taskInfo_async( __cb : AMI_ITask_taskInfo, taskCode : int ) : void ;

    function getTask_async( __cb : AMI_ITask_getTask, npc : int , taskCode : int , choose : int ) : void ;

    function endTask_async( __cb : AMI_ITask_endTask, npc : int , taskCode : int , choose : int ) : void ;

    function cancelTask_async( __cb : AMI_ITask_cancelTask, taskCode : int ) : void ;

    function quickCompleteTask_async( __cb : AMI_ITask_quickCompleteTask, taskCode : int ) : void ;

    function digTreasure_async( __cb : AMI_ITask_digTreasure) : void ;

    function explore_async( __cb : AMI_ITask_explore) : void ;

    function dramaStep_async( __cb : AMI_ITask_dramaStep, step : int ) : void ;
}
}
